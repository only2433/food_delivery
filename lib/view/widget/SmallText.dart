import 'package:flutter/material.dart';
import 'package:food_delivery/utils/Dimensions.dart';

class SmallText extends StatelessWidget {
  final Color? color;
  final String text;
  double size;
  double height;
  bool enableEllipsis;

  SmallText({
    Key? key,
    this.color = const Color(0xffccc7c5),
    required this.text,
    this.size = 0,
    this.height = 1.2,
    this.enableEllipsis = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: enableEllipsis == true ? 1 : null,
      overflow: enableEllipsis == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
          color: color,
          fontSize: size == 0 ? Dimensions.getHeight(12) : size,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
          height: height
      ),
    );
  }
}
