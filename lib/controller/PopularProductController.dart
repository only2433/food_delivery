import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:food_delivery/data/result/ProductItem.dart';
import 'package:food_delivery/repository/PopularProductRepository.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:get/get.dart';

import '../common/Common.dart';
import '../data/result/CartItem.dart';
import '../data/result/Product.dart';
import 'CartController.dart';

class PopularProductController extends GetxController
{
  final PopularProductRepository popularProductRepository;
  PopularProductController({required this.popularProductRepository});

  late CartController _cartController;
  List<ProductItem> _popularProductList = [];
  List<ProductItem> get popularProductList => _popularProductList;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _quantity = 0;
  int get quantity => _quantity;

  int get totalItems{
    return _cartController.totalItems;
  }
  List<CartItem> get getItems {
    return _cartController.getItemList;
  }

  Future<void> getPopularProductList() async
  {
    Response response = await popularProductRepository.getPopularProductList();
    Logger.d("response : ${response.body.toString()}",tag: Common.TAG);
    if(response.statusCode == Common.RESPONSE_SUCCESS)
      {
        _popularProductList = [];
        _popularProductList.addAll(Product.fromJson(response.body).productItemList);
        _isLoaded = true;
        update();
      }
    else
      {

      }
  }

  void initProduct(ProductItem productItem)
  {
    _cartController = Get.find<CartController>();
    _quantity = getStorageQuantity(productItem);
  }

  void addCartItem(ProductItem item)
  {
    if(_quantity > 0)
      {
        _cartController.addItem(item, _quantity);
        update();
      }
    else
      {
        Get.snackbar("Item count", "You should at least add an item in the cart!",
            backgroundColor: AppColors.mainColor,
            colorText: Colors.white,
            duration: Duration(
                milliseconds: 1500
            )
        );
      }
  }

  int getStorageQuantity(ProductItem item)
  {
    var data = _cartController.getItem(item);
    int count = data == null ? 0 : data.quantity!;
    return count;
  }


  void setQuantity(bool isIncrement)
  {
    if(isIncrement)
      {
        _quantity += 1;
      }
    else
      {
        _quantity -= 1;
      }
    _quantity = _checkQuantity(_quantity);
    update();
  }

  int _checkQuantity(int quantity)
  {
    if(quantity < 0)
      {
        Get.snackbar("Item count", "You can`t reduce more!",
          backgroundColor: AppColors.mainColor,
          colorText: Colors.white,
          duration: Duration(
            milliseconds: 1500
          )
        );

        return 0;
      }
    else if(quantity > 20)
      {
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


}