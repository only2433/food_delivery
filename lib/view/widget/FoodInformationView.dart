import 'package:flutter/material.dart';

import '../../utils/Dimensions.dart';
import '../../utils/Colors.dart';
import 'BigText.dart';
import 'IconText.dart';
import 'SmallText.dart';

class FoodInformationView extends StatelessWidget {
  final String text;
  const FoodInformationView({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return getItemInformationView();
  }

  Widget getItemInformationView()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(
            text: text,
            size: Dimensions.getWidth(26)
        ),
        SizedBox(
          height: Dimensions.getHeight(10),
        ),
        Row(
          children: [
            Wrap(
              children: List.generate(5, (index) => Icon(Icons.star, color: AppColors.mainColor, size: 15,)),
            ),
            SizedBox(
              width: 10,
            ),
            SmallText(text: '4.5'),
            SizedBox(width: Dimensions.getWidth(10)),
            SmallText(text: '1287'),
            SizedBox(width: Dimensions.getWidth(5)),
            SmallText(text: 'comments')
          ],
        ),
        SizedBox(
          height: Dimensions.getHeight(20),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconText(
                icon: Icons.circle_sharp,
                text: 'Normal',
                iconColor: AppColors.yellowColor),
            IconText(
                icon: Icons.location_on,
                text: '1.8km',
                iconColor: AppColors.mainColor),
            IconText(
                icon: Icons.access_time_outlined,
                text: '32min',
                iconColor: AppColors.iconColor2)
          ],
        )
      ],
    );
  }
}
