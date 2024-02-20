import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:food_delivery/controller/PopularProductController.dart';
import 'package:food_delivery/controller/RecommendProductController.dart';
import 'package:food_delivery/data/result/ProductItem.dart';
import 'package:food_delivery/route/RouteHelper.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/view/widget/BigText.dart';
import 'package:food_delivery/view/widget/ExpanableText.dart';
import 'package:food_delivery/view/widget/SmallText.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../common/Common.dart';
import '../../../common/CommonUtils.dart';
import '../../../enum/ViewPage.dart';
import '../../../utils/Dimensions.dart';
import '../../widget/AppIcon.dart';

class RecommendFoodDetail extends StatefulWidget {
  final int position;
  final String page;
  const RecommendFoodDetail({
    super.key,
    required this.position,
    required this.page});

  @override
  State<RecommendFoodDetail> createState() => _RecommendFoodDetailState();
}

class _RecommendFoodDetailState extends State<RecommendFoodDetail> {
  late ProductItem productItem;
  ViewPage viewPage = ViewPage.RECOMMAND_DETAIL;
  @override
  void initState() {
    super.initState();
    initData();
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: Dimensions.getHeight(80),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: (){
                      if(viewPage == ViewPage.CART)
                      {
                        Get.toNamed(RouteHelper.getCartPage(ViewPage.CART));
                      }
                      else
                      {
                        Get.toNamed(RouteHelper.getInitial());
                      }
                    },
                    child: AppIcon(icon: Icons.clear)
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
                        AppIcon(icon: Icons.shopping_cart_checkout_outlined,),
                        controller.totalItems > 0 ?
                        Positioned(
                            right: 0,
                            top: 0,
                            child: AppIcon(icon: Icons.circle,
                                size: Dimensions.getWidth(20),
                                iconColor: Colors.transparent,
                                backgroundColor: AppColors.mainColor)
                        ) : Container(),
                        controller.totalItems > 0 ?
                        Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: Dimensions.getWidth(20),
                              height: Dimensions.getHeight(20),
                              alignment: Alignment.center,
                              child: BigText(text: controller.totalItems.toString(),
                                  size: Dimensions.getWidth(12),
                                  color: Colors.white),
                            )
                        ) : Container()
                      ],),
                  );
                })
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(Dimensions.getHeight(20)),
              child: Container(
                alignment: Alignment.center,
                width: double.maxFinite,

                padding: EdgeInsets.only(
                  top: Dimensions.getHeight(10),
                  bottom: Dimensions.getHeight(10)
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.getWidth(20)),
                      topRight: Radius.circular(Dimensions.getWidth(20))
                  )
                ),
                child: BigText(text: productItem.name!),

              ),
            ),
            pinned: true,
            backgroundColor: AppColors.yellowColor,
            expandedHeight: Dimensions.getHeight(300),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                  Common.URL_IMAGE_UPLOAD + productItem.img!,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                  ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  child: ExpandableText(
                    text: productItem.description!,
                    textSize: Dimensions.getWidth(16),
                  ),
                  margin: EdgeInsets.only(
                    left: Dimensions.getWidth(20),
                    right: Dimensions.getWidth(20)
                  ),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: Dimensions.getHeight(60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap:(){
                      controller.setQuantity(false);
                    },
                    child: AppIcon(
                        icon: Icons.remove,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.mainColor
                    ),
                  ),
                  BigText(text: '\$${productItem.price} x ${controller.quantity.toString()}', color: AppColors.mainBlackColor,),
                  GestureDetector(
                    onTap: () {
                      controller.setQuantity(true);
                    },
                    child: AppIcon(
                        icon: Icons.add,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.mainColor
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: Dimensions.getHeight(70),
              color: Colors.grey[200],
              child: Padding(
                padding: EdgeInsets.only(
                    left: Dimensions.getWidth(20),
                    right: Dimensions.getWidth(20)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Dimensions.getWidth(45),
                      height: Dimensions.getHeight(45),
                      child: Icon(
                        Icons.favorite, color: AppColors.mainColor,),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.getWidth(10)),
                              topRight: Radius.circular(Dimensions.getWidth(10)),
                              bottomLeft: Radius.circular(Dimensions.getWidth(10)),
                              bottomRight: Radius.circular(Dimensions.getWidth(10))
                          ),
                          color: Colors.white
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.addCartItem(productItem);
                      },
                      child: Container(
                        width: Dimensions.getWidth(180),
                        height: Dimensions.getHeight(45),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.getWidth(10)),
                              topRight: Radius.circular(Dimensions.getWidth(10)),
                              bottomLeft: Radius.circular(Dimensions.getWidth(10)),
                              bottomRight: Radius.circular(Dimensions.getWidth(10))
                          ),
                          color: AppColors.mainColor,
                        ),
                        child: BigText(
                          text:'\$${productItem.price} | Add to cart',
                          color: Colors.white,)),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      },
      ),
    );
  }

  void initData()
  {
    productItem = Get.find<RecommendProductController>().recommendProductList[widget.position];
    Get.find<PopularProductController>().initProduct(productItem);
    viewPage = CommonUtils.getInstance().getViewPage(widget.page);
    Logger.d(("viewPage : ${viewPage.toString()}"));
  }
}
