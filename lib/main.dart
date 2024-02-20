import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controller/CartController.dart';
import 'package:food_delivery/controller/PopularProductController.dart';
import 'package:food_delivery/controller/RecommendProductController.dart';
import 'package:food_delivery/route/RouteHelper.dart';
import 'package:food_delivery/view/pages/account/LoginPage.dart';
import 'package:food_delivery/view/pages/account/SignupPage.dart';
import 'package:food_delivery/view/pages/cart/CartPage.dart';
import 'package:food_delivery/view/pages/food/PopularFoodDetail.dart';
import 'package:food_delivery/view/pages/food/RecommendFoodDetail.dart';
import 'package:food_delivery/view/pages/home/FoodPageBody.dart';
import 'package:food_delivery/view/pages/home/MainFoodPage.dart';
import 'package:food_delivery/view/pages/splash/SplashPage.dart';
import 'package:get/get.dart';
import 'common/CommonHttpOverrides.dart';
import 'di/Dependencies.dart' as Dependencies;
void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
 // HttpOverrides.global = CommonHttpOverrides();
  await Dependencies.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RouteHelper.getSplashPage(),
      getPages: RouteHelper.routes,
      // home:LoginPage()
    );
  }
}
