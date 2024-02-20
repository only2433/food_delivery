import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:food_delivery/data/firebase/UserData.dart';
import 'package:food_delivery/repository/AuthDataRepository.dart';
import 'package:food_delivery/route/RouteHelper.dart';
import 'package:get/get.dart';

import '../common/Common.dart';
import 'CartController.dart';
import 'PopularProductController.dart';
import 'RecommendProductController.dart';

class AuthDataController extends GetxController {
  Rxn<User> _user = Rxn<User>();
  late UserData _userData;
  final AuthDataRepository authDataRepository;

  AuthDataController({required this.authDataRepository});

  Future<void> syncUserData() async
  {
    _user.bindStream(authDataRepository.firebaseAuth.idTokenChanges());
    ever(_user, (callback) {
      if (_user.value != null) {
        Logger.d("current User get : ${_user.value!.uid}", tag: Common.APP_NAME);
        _loadAPIResource();
        _loadUserData();
        Get.offAllNamed(RouteHelper.getInitial());
      }
      else {
        Logger.d("go to login", tag: Common.APP_NAME);
        Get.offAllNamed(RouteHelper.getLoginPage());
        //LOGIN 페이지로 이동
      }
    });
  }

  Future<void> _loadAPIResource() async
  {
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendProductController>().getRecommendProductList();
  }

  Future<void> _loadUserData() async
  {
    _userData = await authDataRepository.getUserData();
    await Get.find<CartController>().settingStorageCartData();
  }

  Future<UserCredential?> signUp(String email, String password) async
  {
    return authDataRepository.signUpAuth(email, password);
  }

  Future<void> uploadUserData(String uid, File userImage, UserData data) async
  {
    authDataRepository.uploadToSignUpUserData(uid, userImage, data);
  }

  Future<UserCredential> login(String email, String password) async
  {
    final userData = await authDataRepository.login(email, password);
    if(userData != null)
    {
      Logger.d('login : ${userData.user.toString()}', tag: Common.APP_NAME);
    }
    return userData;
  }

  Future<void> logout() async
  {
    await authDataRepository.logout();
  }

}