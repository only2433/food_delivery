import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:food_delivery/controller/AuthDataController.dart';
import 'package:food_delivery/controller/PopularProductController.dart';
import 'package:food_delivery/utils/Colors.dart';

import 'package:food_delivery/view/widget/SmallText.dart';
import 'package:get/get.dart';

import '../../../controller/RecommendProductController.dart';
import '../../../utils/Dimensions.dart';
import '../../widget/BigText.dart';
import 'FoodPageBody.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({super.key});

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: GetBuilder<PopularProductController>(builder: (controller)
      {
          if(controller.popularProductList.length > 0)
            {
              return RefreshIndicator(
                  child: Column(
                    children: [
                      Container(
                        child: Container(
                          margin: EdgeInsets.only(top: Dimensions.getHeight(45), bottom: Dimensions.getHeight(15)),
                          padding: EdgeInsets.only(left: Dimensions.getWidth(20), right: Dimensions.getWidth(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  /**((){
                                    Logger.d("Refresh------------");
                                    return Text("11111");
                                  }()),**/
                                  BigText(text: 'Bangladesh', color: AppColors.mainColor),
                                  Row(
                                    children: [
                                      SmallText(text: 'Narsingdi', color: Colors.black54),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Icon(Icons.arrow_drop_down_rounded)
                                    ],
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () async{
                                  await Get.find<AuthDataController>().logout();
                                },
                                child: Center(
                                  child: Container(
                                    width: Dimensions.getWidth(45),
                                    height: Dimensions.getHeight(45),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.getHeight(15)),
                                      color: AppColors.mainColor,
                                    ),
                                    child: Icon(Icons.logout, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                            child: FoodPageBody(),
                          )
                      )
                    ],
                  ), onRefresh: _loadResource);
            }
            else
              {
                return Center(
                    child: CircularProgressIndicator()
                );
              }
        },
      ),
    );
  }

  Future<void> _loadResource() async
  {
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendProductController>().getRecommendProductList();
  }
}
