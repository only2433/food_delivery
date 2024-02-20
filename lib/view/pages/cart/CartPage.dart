import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:food_delivery/controller/CartController.dart';
import 'package:food_delivery/controller/PopularProductController.dart';
import 'package:food_delivery/controller/RecommendProductController.dart';
import 'package:food_delivery/controller/common/LoadingController.dart';
import 'package:food_delivery/data/result/ProductItem.dart';
import 'package:food_delivery/route/RouteHelper.dart';
import 'package:food_delivery/view/base/NoDataPage.dart';
import 'package:food_delivery/view/widget/BigText.dart';
import 'package:food_delivery/view/widget/SmallText.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../common/Common.dart';
import '../../../common/CommonUtils.dart';
import '../../../data/result/CartItem.dart';
import '../../../enum/ViewPage.dart';
import '../../../utils/Dimensions.dart';
import '../../../utils/Colors.dart';
import '../../widget/AppIcon.dart';
import 'package:get/get.dart';

class CartPage extends StatefulWidget {
  final String page;

  const CartPage({
    super.key,
    required this.page});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
{
  ViewPage viewPage = ViewPage.CART;

  @override
  void initState() {
    super.initState();
    ViewPage viewPage = CommonUtils.getInstance().getViewPage(widget.page);
  }

  @override
  Widget build(BuildContext context) {

    Logger.d(("viewPage : ${viewPage.toString()}"));
    return GetBuilder<LoadingController>(builder: (loading) {
      return ModalProgressHUD(
        inAsyncCall: loading.isLoading,
        child: Scaffold(
            body: Stack(
              children: [
                //Top Icon
                Positioned(
                    left: Dimensions.getWidth(20),
                    right: Dimensions.getWidth(20),
                    top: Dimensions.getHeight(45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back(
                                result: true
                            );
                          },
                          child: AppIcon(
                            icon: Icons.arrow_back,
                            iconColor: Colors.white,
                            backgroundColor: AppColors.mainColor,
                            size: Dimensions.getWidth(36),
                            iconSize: Dimensions.getWidth(20),
                          ),
                        ),
                        SizedBox(
                          width: Dimensions.getWidth(150),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteHelper.getInitial());
                          },
                          child: AppIcon(
                            icon: Icons.home_outlined,
                            iconColor: Colors.white,
                            backgroundColor: AppColors.mainColor,
                            size: Dimensions.getWidth(36),
                            iconSize: Dimensions.getWidth(20),
                          ),
                        ),
                        AppIcon(
                          icon: Icons.shopping_cart,
                          iconColor: Colors.white,
                          backgroundColor: AppColors.mainColor,
                          size: Dimensions.getWidth(36),
                          iconSize: Dimensions.getWidth(20),
                        )
                      ],
                    )),
                GetBuilder<CartController>(builder: (controller) {
                  List<CartItem> list = viewPage == ViewPage.CART ? controller.getItemList : controller.checkoutItemList;
                  return list.length > 0 ? Positioned(
                      top: Dimensions.getHeight(90),
                      left: Dimensions.getWidth(20),
                      right: Dimensions.getWidth(20),
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: Dimensions.getHeight(10),
                        ),
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: GetBuilder<CartController>(builder: (controller) {
                            List<CartItem> list = viewPage == ViewPage.CART ? controller.getItemList : controller.checkoutItemList;
                            return ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: double.maxFinite,
                                  height: Dimensions.getWidth(100),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: Dimensions.getWidth(100),
                                        height: Dimensions.getHeight(100),
                                        margin: EdgeInsets.only(bottom: Dimensions.getHeight(10)),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    Common.URL_IMAGE_UPLOAD + list[index].img!
                                                )
                                            ),
                                            borderRadius: BorderRadius.circular(Dimensions.getWidth(20)),
                                            color: Colors.white
                                        ),
                                      ),
                                      SizedBox(
                                        width: Dimensions.getWidth(10),
                                      ),
                                      Expanded(
                                          child: Container(
                                            height: Dimensions.getHeight(100),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                BigText(text: list[index].name.toString(), color: Colors.black54,),
                                                SmallText(text: 'Spicy'),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    BigText(text: '\$ ${list[index].price.toString()}', color: Colors.redAccent),
                                                    Container(
                                                      width: Dimensions.getWidth(100),
                                                      height: Dimensions.getHeight(50),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(Dimensions.getWidth(10)),
                                                          color: Colors.white
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          viewPage == ViewPage.CART ?
                                                          GestureDetector(
                                                            onTap: () async{
                                                              loading.enable();                                                              await Future.delayed(Duration(
                                                                seconds: 1
                                                              ));
                                                              int currentQuantity = list[index].quantity!;
                                                              await controller.addItem(
                                                                  list[index].productItem!,
                                                                  currentQuantity - 1);
                                                              loading.disable();
                                                            },
                                                            child: Icon(Icons.remove, color: AppColors.signColor,),

                                                          ) : Container(),
                                                          BigText(
                                                              text: list[index].quantity.toString(),
                                                              size: Dimensions.getWidth(18)
                                                          ),
                                                          viewPage == ViewPage.CART ?
                                                          GestureDetector(
                                                              onTap: () async{
                                                                loading.enable();                                                              await Future.delayed(Duration(
                                                                    seconds: 1
                                                                ));
                                                                int currentQuantity = list[index].quantity!;
                                                                await controller.addItem(
                                                                    list[index].productItem!,
                                                                    currentQuantity + 1);
                                                                loading.disable();
                                                              },
                                                              child: Icon(Icons.add, color: AppColors.signColor)
                                                          ) : Container()
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                );
                              },);
                          },
                          ),
                        ),
                      )
                  ) : NoDataPage(text: 'Your cart is empty!');
                },)
              ],
            ),
            bottomNavigationBar: GetBuilder<CartController>(builder: (controller) {
              return viewPage == ViewPage.CART? getCartBottomBar(controller) : getCheckoutDetailBottomBar(controller);
            },
            )
        ),
      );
    },);
  }

  Widget getCheckoutDetailBottomBar(CartController controller)
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
      child: controller.checkoutItemList.length > 0 ? Row(
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

                BigText(
                    text: '\$ ${controller.checkoutAmount.toString()}',
                    size: Dimensions.getWidth(18)
                ),
              ],
            ),
          ),
        ],
      ) : Container(),
    );
  }

  Widget getCartBottomBar(CartController controller)
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
      child: controller.getItemList.length > 0 ? Row(
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

                BigText(
                    text: '\$ ${controller.totalAmount.toString()}',
                    size: Dimensions.getWidth(18)
                ),
              ],    ),
          ),
          SizedBox(
            width: Dimensions.getWidth(20),
          ),
          GestureDetector(
            onTap: () async{
              await controller.clear();
            },
            child: Container(
              alignment: Alignment.center,
              width: Dimensions.getWidth(100),
              height: Dimensions.getHeight(50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.getWidth(20)),
                border: Border.all(
                  width: 1,
                  color: Colors.black
                ),
                color: Colors.white
              ),
              child: BigText(
                text: 'Clear', size: Dimensions.getWidth(18), color: Colors.black,),
            ),
          ),

          GestureDetector(
            onTap: () async {
              await controller.addToHistory();
              await Future.delayed(Duration(seconds: 2));
              Get.toNamed(RouteHelper.getInitial());
            },
            child: Container(
                width: Dimensions.getWidth(100),
                height: Dimensions.getHeight(50),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.getWidth(20)),
                    color: AppColors.mainColor
                ),
                child: BigText(
                  text: 'Checkout',
                  size: Dimensions.getWidth(18),
                  color: Colors.white,
                )
            ),
          )
        ],
      ) : Container(),
    );
  }

  void moveToPage(ProductItem item)
  {
    var index = Get.find<PopularProductController>()
        .popularProductList
        .indexOf(item);

    if(index < 0)
      {
        index = Get.find<RecommendProductController>()
            .recommendProductList
            .indexOf(item);
        Get.toNamed(RouteHelper.getRecommendFood(index, ViewPage.CART));
      }
    else
      {
        Get.toNamed(RouteHelper.getPopularFood(index, ViewPage.CART));
      }
  }


}
