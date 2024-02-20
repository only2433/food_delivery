import 'package:flutter/material.dart';
import 'package:food_delivery/view/widget/SmallText.dart';

import '../../utils/Dimensions.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  double iconSize;
  double textSize;

  IconText({super.key,
    required this.icon, 
    required this.text,
    required this.iconColor,
    this.textSize = 0,
    this.iconSize = 0});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: iconSize == 0 ? Dimensions.getWidth(24) : iconSize,
        ),
        SizedBox(
          width: Dimensions.getWidth(2),
        ),
        SmallText(
          text: text,
          size: textSize == 0 ? 0 : textSize)
      ],
    );
  }
}
