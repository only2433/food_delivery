import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:food_delivery/controller/CartController.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/view/base/NoDataPage.dart';
import 'package:food_delivery/view/widget/AppIcon.dart';
import 'package:food_delivery/view/widget/BigText.dart';
import 'package:food_delivery/view/widget/SmallText.dart';
import 'package:get/get.dart';

import '../../../common/Common.dart';
import '../../../common/CommonUtils.dart';
import '../../../data/result/CartItem.dart';
import '../../../enum/ViewPage.dart';
import '../../../route/RouteHelper.dart';
import '../../../utils/Dimensions.dart';

class CartHistory extends StatefulWidget
{
  const CartHistory({super.key});

  @override
  State<CartHistory> createState() => _CartHistoryState();
}

class _CartHistoryState extends State<CartHistory>
{
  var listCounter = 0;


  @override
  void initState()
  {
    super.initState();
    Get.find<CartController>().getCartHistoryList();
  }


  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
      body: GetBuilder<CartController>(builder: (controller) {
       if(controller.cartHistoryList != null)
         {
           return Column(
             children: [
               Container(
                 color: AppColors.mainColor,
                 width: double.maxFinite,
                 height: Dimensions.getHeight(90),
                 padding: EdgeInsets.only(top: Dimensions.getHeight(25)),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     BigText(text: "Cart History", color: Colors.white,),
                     AppIcon(
                       icon: Icons.shopping_cart_outlined,
                       iconColor: AppColors.mainColor,
                       backgroundColor: Colors.white,)
                   ],
                 ),
               ),
               controller.cartHistoryList!.length > 0 ? Expanded(
                 child: Container(
                   margin: EdgeInsets.only(
                       top: Dimensions.getHeight(20),
                       left: Dimensions.getWidth(20),
                       right: Dimensions.getWidth(20)
                   ),
                   child: MediaQuery.removePadding(
                     context: context,
                     removeTop: true,
                     child: ListView(
                       children: [
                         for(int i = 0; i < controller.itemsPerOrderCountList.length; i++)
                           Container(
                             margin: EdgeInsets.only(
                               bottom: Dimensions.getHeight(20),
                             ),
                             height: Dimensions.getHeight(120),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 BigText(text: CommonUtils.getInstance().getCheckoutDate(
                                     controller.cartHistoryList![listCounter].time!
                                 )),
                                 SizedBox(
                                   height: Dimensions.getHeight(10),
                                 ),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Wrap(
                                       direction: Axis.horizontal,
                                       children: List.generate(controller.itemsPerOrderCountList[i], (index){
                                         if(listCounter >= controller.cartHistoryList!.length)
                                         {
                                           listCounter = controller.cartHistoryList!.length -1;
                                         }
                                         return index <= 2 ? Padding(
                                           padding:  EdgeInsets.only(right: Dimensions.getWidth(5)),
                                           child: Container(
                                             width: Dimensions.getWidth(80),
                                             height: Dimensions.getHeight(80),
                                             decoration: BoxDecoration(
                                               borderRadius: BorderRadius.circular(Dimensions.getWidth(10)),
                                               image: DecorationImage(
                                                   fit: BoxFit.cover,
                                                   image: NetworkImage(Common.URL_IMAGE_UPLOAD + controller.cartHistoryList![listCounter++].img!)
                                               ),
                                             ),

                                           ),
                                         ) : Container();
                                       }),
                                     ),
                                     Container(

                                       height: Dimensions.getHeight(80),
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.end,
                                         children: [
                                           SmallText(text: 'Total'),
                                           SizedBox(
                                             height: Dimensions.getHeight(5),
                                           ),
                                           BigText(text: controller.itemsPerOrderCountList[i].toString()+" Items"),
                                           SizedBox(
                                             height: Dimensions.getHeight(5),
                                           ),
                                           GestureDetector(
                                             onTap: () {
                                               Map<int, CartItem> data = CommonUtils.getInstance().getCartItemForPerTimes(controller.cartHistoryList!, controller.itemsPerOrderTimeList[i]);

                                               Logger.d("data : ${data.toString()}");
                                               Get.find<CartController>().setCheckoutDetailItems(data);
                                               Get.toNamed(RouteHelper.getCartPage(ViewPage.CART_DETAIL));
                                             },
                                             child: Container(
                                               padding: EdgeInsets.symmetric(
                                                   horizontal: Dimensions.getWidth(10),
                                                   vertical: Dimensions.getHeight(5)),

                                               decoration: BoxDecoration(
                                                 borderRadius: BorderRadius.circular(Dimensions.getWidth(5)),
                                                 border: Border.all(
                                                   width: 1,
                                                   color: AppColors.mainColor,
                                                 ),
                                               ),
                                               child: SmallText(
                                                   text:'detail',
                                                   color: AppColors.mainColor),
                                             ),
                                           )
                                         ],
                                       ),
                                     )
                                   ],
                                 )
                               ],
                             ),
                           )
                       ],
                     ),
                   ),
                 ),
               ) : Container(

                 height: MediaQuery.of(context).size.height / 1.3,
                 child: NoDataPage(
                   text: 'You didn`t buy anything so far !',
                   imgPath: "asset/image/empty_box.png",),
               )
             ],
           );
         }
       else
         {
           return Center(
             child: CircularProgressIndicator(),
           );
         }
      },),
    );
  }


}
