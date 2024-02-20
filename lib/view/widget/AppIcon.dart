import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../utils/Dimensions.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  double size;
  double iconSize;

  AppIcon({
    Key? key,
    required this.icon,
    this.backgroundColor = const Color(0xFFfcf4e4),
    this.iconColor = const Color(0xFF756d54),
    this.size = 0,
    this.iconSize = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: size == 0 ? Dimensions.getWidth(40) : size,
      height: size == 0 ? Dimensions.getWidth(40) : size,
      decoration: BoxDecoration(
        borderRadius: size == 0 ? BorderRadius.circular(Dimensions.getWidth(20)) : BorderRadius.circular(Dimensions.getWidth(size/2)),
        color: backgroundColor
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize == 0 ? Dimensions.getWidth(15) : Dimensions.getWidth(iconSize),
      ),
    );
  }
}
