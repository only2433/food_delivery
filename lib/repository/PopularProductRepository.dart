import 'package:food_delivery/api/ApiClient.dart';
import 'package:get/get.dart';

import '../common/Common.dart';

class PopularProductRepository extends GetxService
{
  final ApiClient apiClient;

  PopularProductRepository({required this.apiClient});

  Future<Response> getPopularProductList() async
  {
    return await apiClient.getData(Common.API_POPULAR_PRODUCT_LIST);
  }
}