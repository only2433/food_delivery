import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:food_delivery/data/result/ProductItem.dart';
import 'package:food_delivery/repository/PopularProductRepository.dart';
import 'package:get/get.dart';

import '../common/Common.dart';
import '../data/result/Product.dart';
import '../repository/RecommendProductRepository.dart';

class RecommendProductController extends GetxController
{
  List<ProductItem> _recommendProductList = [];
  bool _isLoaded = false;

  final RecommendProductRepository recommendProductRepository;
  RecommendProductController({required this.recommendProductRepository});

  List<ProductItem> get recommendProductList => _recommendProductList;
  bool get isLoaded => _isLoaded;

  Future<void> getRecommendProductList() async
  {
    Response response = await recommendProductRepository.getRecommendProduct();
    Logger.d("response : ${response.body.toString()}",tag: Common.TAG);
    if(response.statusCode == Common.RESPONSE_SUCCESS)
    {
      _recommendProductList = [];
      _recommendProductList.addAll(Product.fromJson(response.body).productItemList);
      _isLoaded = true;
      update();
    }
    else
    {

    }
  }
}