import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:get/get.dart';


import '../common/Common.dart';
import '../common/CommonUtils.dart';
import '../data/result/CartItem.dart';
import '../data/result/ProductItem.dart';
import '../repository/CartRepository.dart';
import '../utils/Colors.dart';

class CartController extends GetxController {
  final CartRepository cartRepository;

  CartController({required this.cartRepository});

  Map<int, CartItem> _items = {};
  Map<int, CartItem> _checkoutDetailItems = {};
  List<CartItem>? cartHistoryList = null;
  late List<int> itemsPerOrderCountList;
  late List<String> itemsPerOrderTimeList;

  List<CartItem> get getItemList {
    return _items.entries.map((e) {
      return e.value;
    }).toList();
  }

  List<CartItem> get checkoutItemList{
    return _checkoutDetailItems.entries.map((e) {
      return e.value;
    }).toList();
  }

  List<CartItem> storageItems = [];

  Future<void> settingStorageCartData() async {
    storageItems = await cartRepository.getCartList();
    for (int i = 0; i < storageItems.length; i++) {
      Logger.d("index : $i , data : ${storageItems[i].productItem!.toString()!}", tag: Common.APP_NAME);
      _items.putIfAbsent(storageItems[i].productItem!.id!, () {
        return storageItems[i];
      });
    }
  }

  Future<void> addItem(ProductItem product, int quantity) async{
    if (_items.containsKey(product.id!)) {
      quantity = _checkQuantity(quantity);
      if (quantity == 0) {
        _items.remove(product.id!);
      }
      else {
        _items.update(product.id!, (value) {
          return CartItem(
              id: product.id,
              name: product.name,
              price: product.price,
              img: product.img,
              isExit: true,
              quantity: quantity,
              time: DateTime.now().toString(),
              productItem: product
          );
        });
      }
    }
    else {
      _items.putIfAbsent(product.id!, () {
        Logger.d("adding item to the cart id ${product.id!.toString()}, quantity : $quantity");
        return CartItem(
            id: product.id,
            name: product.name,
            price: product.price,
            img: product.img,
            isExit: true,
            quantity: quantity,
            time: DateTime.now().toString(),
            productItem: product
        );
      });
    }
    await cartRepository.addToCartList(getItemList);
    update();
  }

  CartItem? getItem(ProductItem product) {
    if (_items.containsKey(product.id!)) {
      return _items[product.id!];
    }
    else {
      return null;
    }
  }

  int get totalItems {
    var totalQuantity = 0;
    _items.forEach((key, value) {
      totalQuantity += value.quantity!;
    });
    return totalQuantity;
  }

  int _checkQuantity(int quantity) {
    if (quantity < 0) {
      return 0;
    }
    else if (quantity > 20) {
      Get.snackbar("Item count", "You can`t add more!",
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white,
          duration: Duration(
              milliseconds: 1500
          )
      );
      return 20;
    }

    return quantity;
  }

  int get totalAmount {
    var total = 0;
    _items.forEach((key, value) {
      total += (value.quantity! * value.price!);
    });
    return total;
  }

  int get checkoutAmount{
    var total = 0;
    _checkoutDetailItems.forEach((key, value) {
      total += (value.quantity! * value.price!);
    });
    return total;
  }

  Future<void> addToHistory() async{
    await cartRepository.addToCartHistoryList();
    await clear();
    Get.snackbar("Checkout", "You have successfully paid for the items in your cart.!",
        backgroundColor: AppColors.mainColor,
        colorText: Colors.white,
        duration: Duration(
            milliseconds: 1500
        )
    );
  }

  Future<void> clear() async{
    _items.clear();
    await cartRepository.removeCartList();
    update();
  }

  void setCheckoutDetailItems(Map<int, CartItem> data)
  {
    _checkoutDetailItems = {};
    _checkoutDetailItems = data;
    update();
  }


  Future<void> getCartHistoryList() async
  {
    Logger.d("getCartHistoryList request");
    cartHistoryList = await cartRepository.getCartHistoryList();

    Logger.d("getCartHistoryList complete");
    cartHistoryList = cartHistoryList!.reversed.toList();
    Map<String, int> cartItemsPerOrder = CommonUtils.getInstance().getPerOrderForCartItems(cartHistoryList!);
    itemsPerOrderCountList = cartItemsPerOrder.entries.map((e) => e.value).toList();
    itemsPerOrderTimeList = cartItemsPerOrder.entries.map((e) => e.key).toList();
    update();
  }
}