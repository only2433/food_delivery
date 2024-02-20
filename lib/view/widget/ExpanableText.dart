import 'package:flutter/material.dart';
import 'package:food_delivery/view/widget/SmallText.dart';

import '../../utils/Dimensions.dart';
import '../../utils/Colors.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  double textSize;
  ExpandableText({
    super.key,
    required this.text,
    this.textSize = 0});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String firstHalf;
  late String secondHalf;
  bool hiddenText = true;

  double textHeight = Dimensions.getHeight(130);

  // i love flutter laravel and goland 30
  @override
  void initState() {
    super.initState();
    if(widget.text.length > textHeight)
    {
        firstHalf = widget.text.substring(0,textHeight.toInt());
        secondHalf = widget.text.substring(textHeight.toInt() + 1, widget.text.length);
        hiddenText = true;
    }
    else
    {
        firstHalf = widget.text;
        secondHalf = "";
        hiddenText = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty ?
      SmallText(
          text: firstHalf,
          size: widget.textSize == 0 ? Dimensions.getWidth(14) : Dimensions.getWidth(widget.textSize),
          color: AppColors.paraColor) :
      Column(
        children: [
          SmallText(
              text: hiddenText ? (firstHalf + "...") : (firstHalf + secondHalf),
              size: widget.textSize == 0 ? Dimensions.getWidth(14) : Dimensions.getWidth(widget.textSize),
              color: AppColors.paraColor,
              height: Dimensions.getHeight(1.3),),
          SizedBox(
            height: Dimensions.getHeight(5),
          ),
          InkWell(
            onTap: () {
              setState(() {
                hiddenText = !hiddenText;
              });
            },
            child: Row(
              children: [
                SmallText(text: hiddenText ? 'Show more' : 'Show less', color: AppColors.mainColor),
                SizedBox(
                  width: Dimensions.getWidth(2),
                ),
                Icon(hiddenText ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                    color: AppColors.mainColor)
              ],
            ),
          )
        ],
      ),
    );
  }
}
