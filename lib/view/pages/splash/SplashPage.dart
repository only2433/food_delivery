import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery/controller/AuthDataController.dart';
import 'package:food_delivery/route/RouteHelper.dart';
import 'package:get/get.dart';

import '../../../controller/PopularProductController.dart';
import '../../../controller/RecommendProductController.dart';
import '../../../utils/Dimensions.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {

  late Animation<double> animation;
  late AnimationController _controller;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 2000)
    )..forward();
    animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    Timer(Duration(seconds: 3), (){
      _getDataAndAnimation();
    });
  }

  Future<void> _getDataAndAnimation() async{
    await Get.find<AuthDataController>().syncUserData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Container(
              width: double.maxFinite,
              height: Dimensions.getHeight(200),
              alignment: Alignment.center,
              child: Image.asset('asset/image/logo part 1.png'),
            ),
          ),
          Image.asset('asset/image/logo part 2.png',
            width: Dimensions.getWidth(200),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
