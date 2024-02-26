import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../data/result/CartItem.dart';

class CartHistoryRepository extends GetxService
{
  final FirebaseAuth firebaseAuth;
  CartHistoryRepository({required this.firebaseAuth});

  List<CartItem> cartHistoryList = [];

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
}