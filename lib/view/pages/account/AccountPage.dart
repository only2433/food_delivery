import 'package:flutter/material.dart';
import 'package:food_delivery/common/CommonUtils.dart';
import 'package:food_delivery/controller/AuthDataController.dart';
import 'package:food_delivery/view/widget/AccountWidget.dart';
import 'package:food_delivery/view/widget/BigText.dart';
import 'package:get/get.dart';

import '../../../utils/Dimensions.dart';
import '../../../utils/Colors.dart';
import '../../widget/AppIcon.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: BigText(
          text: 'Profile',
          size: Dimensions.getWidth(24),
          color: Colors.white,
        ),
      ),
      body: GetBuilder<AuthDataController>(builder: (controller) {
        return Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(
              top: Dimensions.getHeight(20)
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: Dimensions.getHeight(60),
                backgroundColor: AppColors.mainColor,
                child: ClipOval(
                  child: SizedBox(
                    width: Dimensions.getWidth(110),
                    height: Dimensions.getHeight(110),
                    child: Image.network(controller.getUserData().userImage, fit: BoxFit.cover,),
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.getHeight(20),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AccountWidget(
                          appIcon: AppIcon(
                            icon: Icons.person,
                            backgroundColor: AppColors.mainColor,
                            iconColor: Colors.white,
                            iconSize: Dimensions.getWidth(20),
                            size: Dimensions.getWidth(50),
                          ), bigText: BigText(text: controller.getUserData().userName)
                      ),
                      SizedBox(
                        height: Dimensions.getHeight(20),
                      ),
                      AccountWidget(
                          appIcon: AppIcon(
                            icon: Icons.phone,
                            backgroundColor: AppColors.yellowColor,
                            iconColor: Colors.white,
                            iconSize: Dimensions.getWidth(20),
                            size: Dimensions.getWidth(50),
                          ), bigText: BigText(text: "${CommonUtils.getInstance().getPhoneNumber(controller.getUserData().userPhoneNumber)}")
                      ),
                      SizedBox(
                        height: Dimensions.getHeight(20),
                      ),
                      AccountWidget(
                          appIcon: AppIcon(
                            icon: Icons.email_outlined,
                            backgroundColor: Colors.redAccent,
                            iconColor: Colors.white,
                            iconSize: Dimensions.getWidth(20),
                            size: Dimensions.getWidth(50),
                          ), bigText: BigText(text: controller.getUserData().userEmail)
                      ),
                      SizedBox(
                        height: Dimensions.getHeight(20),
                      ),
                      AccountWidget(
                          appIcon: AppIcon(
                            icon: Icons.location_on,
                            backgroundColor: Colors.lightBlueAccent,
                            iconColor: Colors.white,
                            iconSize: Dimensions.getWidth(20),
                            size: Dimensions.getWidth(50),
                          ), bigText: BigText(text: "서울시 용산구 백범로 99길 40")
                      ),
                      SizedBox(
                        height: Dimensions.getHeight(20),
                      ),
                      AccountWidget(
                          appIcon: AppIcon(
                            icon: Icons.calendar_month_outlined,
                            backgroundColor: Colors.green.shade500,
                            iconColor: Colors.white,
                            iconSize: Dimensions.getWidth(20),
                            size: Dimensions.getWidth(50),
                          ), bigText: BigText(text: "${CommonUtils.getInstance().getUserBirthday(controller.getUserData().userBirthday)}")
                      ),
                      SizedBox(
                        height: Dimensions.getHeight(20),
                      ),
                    ],
                  ),
                ),
              )

            ],
          ),
        );
      },),
    );
  }
}
