import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:food_delivery/controller/PopularProductController.dart';
import 'package:food_delivery/route/RouteHelper.dart';
import 'package:food_delivery/utils/Dimensions.dart';
import 'package:food_delivery/view/widget/ExpanableText.dart';
import 'package:get/get.dart';

import '../../../common/Common.dart';
import '../../../common/CommonUtils.dart';
import '../../../controller/CartController.dart';
import '../../../data/result/ProductItem.dart';
import '../../../enum/ViewPage.dart';
import '../../../utils/Colors.dart';
import '../../widget/AppIcon.dart';
import '../../widget/BigText.dart';
import '../../widget/FoodInformationView.dart';
import '../../widget/IconText.dart';
import '../../widget/SmallText.dart';

class PopularFoodDetail extends StatefulWidget {
  final int position;
  final String page;
  PopularFoodDetail({
    super.key,
    required this.position,
    required this.page
  });

  @override
  State<PopularFoodDetail> createState() => _PopularFoodDetailState();
}

class _PopularFoodDetailState extends State<PopularFoodDetail>
{
  ViewPage viewPage = ViewPage.POPULAR_DETAIL;
  late ProductItem productItem;


  @override
  void initState()
  {
    super.initState();
    Logger.d("initState");
    initData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //Background Image
          Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: Dimensions.getHeight(350),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        Common.URL_IMAGE_UPLOAD + productItem.img!
                    )
                  )
                ),
          )),
          // Top Icon
          Positioned(
              left: Dimensions.getWidth(20),
              right: Dimensions.getWidth(20),
              top: Dimensions.getHeight(45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap:() {
                      if(viewPage == ViewPage.CART)
                        {
                          Get.toNamed(RouteHelper.getCartPage(ViewPage.CART));
                        }
                      else
                        {
                          Get.toNamed(RouteHelper.getInitial());
                        }
                    },
                    child: AppIcon(
                      icon: Icons.arrow_back,
                    ),
                  ),
                 GetBuilder<PopularProductController>(builder: (controller) {
                   return GestureDetector(
                     onTap: () async{
                       if(controller.totalItems > 0)
                         {
                          final result = await Get.toNamed(RouteHelper.getCartPage(ViewPage.CART));
                          if(result != null)
                            {
                              initData();
                              controller.update();
                            }
                         }
                     },
                     child: Stack(
                       children: [
                         AppIcon(
                           icon: Icons.shopping_cart_outlined,
                         ),
                         controller.totalItems > 0 ?
                             Positioned(
                               right: 0,
                               top: 0,
                               child: AppIcon(icon: Icons.circle,
                                 size: Dimensions.getWidth(20),
                                 iconColor: Colors.transparent,
                                  backgroundColor: AppColors.mainColor,),
                             ) :
                             Container(),
                         controller.totalItems > 0 ?
                         Positioned(
                           right: 0,
                           top: 0,
                           child: Container(
                             width: Dimensions.getWidth(20),
                             height: Dimensions.getHeight(20),
                             child: BigText(
                               text: controller.totalItems.toString(),
                               size: Dimensions.getWidth(12),
                               color: Colors.white,),
                             alignment: Alignment.center,
                           ),
                         ) :
                         Container()
                       ],
                     ),
                   );
                  },
                 )
                ],
          )),
          //Food Information
          Positioned(
              left: 0,
              right: 0,
              top: Dimensions.getHeight(330),
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(
                  left: Dimensions.getWidth(20),
                  right: Dimensions.getWidth(20),
                  top: Dimensions.getHeight(20)
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.getWidth(20)),
                    topRight: Radius.circular(Dimensions.getWidth(20))
                  ),
                  color: Colors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FoodInformationView(text: productItem.name!),
                    SizedBox(
                      height: Dimensions.getHeight(20),
                    ),
                    BigText(text: 'Introduce'),
                    SizedBox(
                      height: Dimensions.getHeight(10),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                            child: ExpandableText(text: productItem.description!)))
                  ],
                ),
          )),

        ],
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(builder: (controller)
      {
          return Container(
            height: Dimensions.getHeight(100),
            padding: EdgeInsets.only(
                top: Dimensions.getHeight(30),
                bottom: Dimensions.getHeight(30),
                left: Dimensions.getWidth(20),
                right: Dimensions.getWidth(20)
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.getWidth(20)),
                    topRight: Radius.circular(Dimensions.getWidth(20))
                ),
                color: AppColors.buttonBackgroundColor
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Dimensions.getWidth(100),
                  height: Dimensions.getHeight(50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.getWidth(20)),
                      color: Colors.white
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            controller.setQuantity(false);
                          },
                          child: Icon(Icons.remove, color: AppColors.signColor,),

                      ),
                      BigText(
                          text: controller.quantity.toString(),
                          size: Dimensions.getWidth(18)
                      ),
                      GestureDetector(
                          onTap:() {
                            controller.setQuantity(true);
                          },
                          child: Icon(Icons.add, color: AppColors.signColor))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.addCartItem(productItem);
                  },
                  child: Container(
                      width: Dimensions.getWidth(180),
                      height: Dimensions.getHeight(50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.getWidth(20)),
                          color: AppColors.mainColor
                      ),
                      child: BigText(
                        text: '\$${productItem.price} | Add to cart',
                        size: Dimensions.getWidth(18),
                        color: Colors.white,
                      )
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void initData()
  {
    productItem = Get.find<PopularProductController>().popularProductList[widget.position];
    Get.find<PopularProductController>().initProduct(productItem);
    viewPage = CommonUtils.getInstance().getViewPage(widget.page);
    Logger.d(("viewPage : ${viewPage.toString()}"));
  }
}
