import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/api/ApiClient.dart';
import 'package:food_delivery/controller/CartController.dart';
import 'package:food_delivery/controller/AuthDataController.dart';
import 'package:food_delivery/controller/CartHistoryController.dart';
import 'package:food_delivery/controller/PopularProductController.dart';
import 'package:food_delivery/controller/RecommendProductController.dart';
import 'package:food_delivery/controller/common/LoadingController.dart';
import 'package:food_delivery/repository/CartHistoryRepository.dart';
import 'package:food_delivery/repository/CartRepository.dart';
import 'package:food_delivery/repository/AuthDataRepository.dart';
import 'package:food_delivery/repository/PopularProductRepository.dart';
import 'package:food_delivery/repository/RecommendProductRepository.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/Common.dart';

Future<void> init() async
{
  final firebaseAuth = FirebaseAuth.instance;
  Get.put(firebaseAuth);

  Get.put(LoadingController());

  final apiClient = ApiClient(appBaseUrl: Common.BASE_API_URL);
  Get.put(apiClient);

  final popularProductRepository = PopularProductRepository(apiClient: Get.find());
  Get.put(popularProductRepository);

  final recommendProductRepository = RecommendProductRepository(apiClient: Get.find());
  Get.put(recommendProductRepository);

  final cartRepository = CartRepository(firebaseAuth: Get.find());
  Get.put(cartRepository);

  final cartHistoryRepository = CartHistoryRepository(firebaseAuth: Get.find());
  Get.put(cartHistoryRepository);

  final authDataRepository = AuthDataRepository(firebaseAuth: Get.find());
  Get.put(authDataRepository);

  final popularProductController = PopularProductController(popularProductRepository: Get.find());
  Get.put(popularProductController);

  final recommendProductController = RecommendProductController(recommendProductRepository: Get.find());
  Get.put(recommendProductController);

  final cartController = CartController(cartRepository: Get.find());
  Get.put(cartController);

  final cartHistoryController = CartHistoryController(cartHistoryRepository: Get.find());
  Get.put(cartHistoryController);

  final authDataController = AuthDataController(authDataRepository: Get.find());
  Get.put(authDataController);
}
