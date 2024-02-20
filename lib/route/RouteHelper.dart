import 'package:flutter/cupertino.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:food_delivery/view/pages/account/LoginPage.dart';
import 'package:food_delivery/view/pages/account/SignupPage.dart';
import 'package:food_delivery/view/pages/cart/CartPage.dart';
import 'package:food_delivery/view/pages/food/PopularFoodDetail.dart';
import 'package:food_delivery/view/pages/food/RecommendFoodDetail.dart';
import 'package:food_delivery/view/pages/home/MainFoodPage.dart';
import 'package:food_delivery/view/pages/splash/SplashPage.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../common/CommonUtils.dart';
import '../data/result/ProductItem.dart';
import '../enum/ViewPage.dart';
import '../view/pages/home/HomePage.dart';

class RouteHelper {
  static const String _SPLASH = "/splash-page";
  static const String _LOGIN = "/login";
  static const String _SIGN_UP = "/sign_up";
  static const String _INITIAL = "/";
  static const String _POPULAR_FOOD = "/popular-food";
  static const String _RECOMMEND_FOOD = "/recommend-food";
  static const String _CART_PAGE = "/cart-page";

  static String getSplashPage() => '$_SPLASH';
  static String getLoginPage() => '$_LOGIN';
  static String getSignUpPage() => '$_SIGN_UP';
  static String getInitial() => '$_INITIAL';

  static String getPopularFood(int position, ViewPage departurePage) {
    String pageName = departurePage.getStringValue;
    return '$_POPULAR_FOOD?position=$position&page=${departurePage.getStringValue}';
  }

  static String getRecommendFood(int position, ViewPage departurePage) {
    String pageName = departurePage.getStringValue;
    return '$_RECOMMEND_FOOD?position=$position&page=${departurePage.getStringValue}';
  }

  static String getCartPage(ViewPage requestPage) {
    return '$_CART_PAGE?page=${requestPage.getStringValue}';
  }

  static List<GetPage> routes = [
    GetPage(
        name: _SPLASH,
        page: () {
          Logger.d("Splash page called");
          return SplashPage();
        }),
    GetPage(
        name: _LOGIN,
        transition: Transition.rightToLeftWithFade,
        page: (){
          Logger.d("Login page called");
          return LoginPage();
        }),
    GetPage(
        name: _SIGN_UP,
        transition: Transition.rightToLeftWithFade,
        page: (){
          Logger.d("SignUp page called");
          return SignupPage();
        }),
    GetPage(
        name: _INITIAL,
        page: () {
          Logger.d("Main Food page called");
          return HomePage();
        }),
    GetPage(
      name: _POPULAR_FOOD,
      page: () {
        Logger.d("Popular Food Detail page called");
        var position = Get.parameters['position'];
        String page = Get.parameters['page']!;
        return PopularFoodDetail(position: int.parse(position!), page: page);
      },
    ),
    GetPage(
      name: _RECOMMEND_FOOD,
      page: () {
        Logger.d("Recommend food Detail page called");
        var position = Get.parameters['position'];
        var page = Get.parameters['page'];
        return RecommendFoodDetail(position: int.parse(position!), page: page.toString());
      },
    ),
    GetPage(
        name: _CART_PAGE,
        page: () {
          Logger.d("Cart page called");
          var page = Get.parameters['page'];
          Logger.d("page : ${page}");
          return CartPage(
            page: page.toString(),
          );
        })
  ];
}
