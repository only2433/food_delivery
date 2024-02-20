import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:food_delivery/api/ApiClient.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/Common.dart';
import '../data/result/CartItem.dart';

class CartRepository extends GetxService
{
  final FirebaseAuth firebaseAuth;
  CartRepository({required this.firebaseAuth});

  List<CartItem> cartList = [];
  List<CartItem> cartHistoryList = [];

  Future<void> addToCartList(List<CartItem> list) async
  {
    cartList = [];
    DateTime addCartDateTime = DateTime.now();
    list.forEach((element) {
      element.time = addCartDateTime.toString();
      cartList.add(element);
    });
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(firebaseAuth.currentUser!.uid)
        .set({
              'itemList' : cartList.map((item) => item.toJson()).toList()
            });
  }

  Future<List<CartItem>> getCartList() async
  {
    var snapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
    if(snapshot.exists)
    {
      Map<String, dynamic> data = snapshot.data()!;
      var list = data['itemList'].map((item) => CartItem.fromJson(item)).toList();
      cartList = List<CartItem>.from(list);

      Logger.d("cartList size : ${cartList.length}");
      return cartList;
    }
    else
    {
      cartList = [];
    }
    return cartList;
  }

  Future<List<CartItem>> getCartHistoryList() async
  {
    var snapshot = await FirebaseFirestore.instance
        .collection('history')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    if(snapshot.exists)
    {
      Map<String, dynamic> data = snapshot.data()!;
      var list = data['itemList'].map((item) => CartItem.fromJson(item)).toList();
      cartHistoryList = List<CartItem>.from(list);
      return cartHistoryList;
    }
    else
    {
      cartHistoryList = [];
    }
    return cartHistoryList;
  }

  Future<void> addToCartHistoryList() async
  {
    var data = await getCartHistoryList();
    for(int i = 0; i < cartList.length; i++ )
    {
      data.add(cartList[i]);
    }
    await FirebaseFirestore.instance
        .collection('history')
        .doc(firebaseAuth.currentUser!.uid)
        .set({
          'itemList' : cartList.map((item) => item.toJson()).toList()
        });
  }

  Future<void> removeCartList() async
  {
    cartList = [];
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
          'itemList': FieldValue.delete()
        });
  }

}