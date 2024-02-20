import 'package:flutter/material.dart';
import 'package:food_delivery/view/widget/AccountWidget.dart';
import 'package:food_delivery/view/widget/BigText.dart';

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
      body: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(
          top: Dimensions.getHeight(20)
        ),
        child: Column(
          children: [
            AppIcon(
              icon: Icons.person,
              iconColor: Colors.white,
              iconSize: Dimensions.getWidth(75),
              backgroundColor: AppColors.mainColor,
              size: Dimensions.getWidth(150),
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
                        ), bigText: BigText(text: "정재현")
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
                        ), bigText: BigText(text: "010-2765-0727")
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
                        ), bigText: BigText(text: "only340@gmail.com")
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
                          icon: Icons.message,
                          backgroundColor: Colors.green.shade500,
                          iconColor: Colors.white,
                          iconSize: Dimensions.getWidth(20),
                          size: Dimensions.getWidth(50),
                        ), bigText: BigText(text: "잘 부탁 드립니다.")
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
      ),
    );
  }
}
