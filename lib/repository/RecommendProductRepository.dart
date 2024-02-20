import 'package:get/get.dart';

import '../api/ApiClient.dart';
import '../common/Common.dart';

class RecommendProductRepository extends GetxService
{
  final ApiClient apiClient;

  RecommendProductRepository({required this.apiClient});

  Future<Response> getRecommendProduct() async
  {
    return await apiClient.getData(Common.API_RECOMMEND_PRODUCT);
  }
}