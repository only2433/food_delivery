import 'package:flutter/material.dart';

import '../../utils/Dimensions.dart';
import 'AppIcon.dart';
import 'BigText.dart';

class AccountWidget extends StatelessWidget {
  final AppIcon appIcon;
  final BigText bigText;
  const AccountWidget({
    super.key,
    required this.appIcon,
    required this.bigText
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Dimensions.getWidth(20),
        top: Dimensions.getHeight(10),
        bottom: Dimensions.getHeight(10)
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            offset: Offset(0,2),
            color: Colors.grey.withOpacity(0.2)
          )
        ]
      ),
      child: Row(
        children: [
          appIcon,
          SizedBox(
            width: Dimensions.getWidth(10),
          ),
          bigText
        ],
      ),
    );
  }
}
