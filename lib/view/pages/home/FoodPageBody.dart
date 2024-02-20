import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:food_delivery/controller/PopularProductController.dart';
import 'package:food_delivery/controller/RecommendProductController.dart';
import 'package:food_delivery/route/RouteHelper.dart';
import 'package:food_delivery/utils/Colors.dart';
import 'package:food_delivery/view/pages/food/PopularFoodDetail.dart';
import 'package:food_delivery/view/widget/BigText.dart';
import 'package:food_delivery/view/widget/FoodInformationView.dart';
import 'package:food_delivery/view/widget/IconText.dart';
import 'package:food_delivery/view/widget/SmallText.dart';
import 'package:get/get.dart';
import '../../../common/Common.dart';
import '../../../data/result/ProductItem.dart';
import '../../../enum/ViewPage.dart';
import '../../../utils/Dimensions.dart';


class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key});

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {

  PageController pageController = PageController(viewportFraction: 0.85);
  var _currentPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _scaleHeight = Dimensions.getHeight(220);

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currentPageValue = pageController.page!;
      });
    });
  }


  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<PopularProductController>(builder: (controller) {
          return Container(
            height: Dimensions.getHeight(320),
            child: PageView.builder(
              controller: pageController,
              itemCount: controller.popularProductList.length,
              itemBuilder: (context, index) {
                return _buildPageItem(index, controller.popularProductList[index]);
              },
            )
          );
          },
        ),
        GetBuilder<PopularProductController>(builder: (controller) {
            return new DotsIndicator(
                dotsCount: controller.popularProductList.length,
                position: _currentPageValue,
                decorator: DotsDecorator(
                    activeColor: AppColors.mainColor,
                    size: const Size.square(9.0),
                    activeSize: const Size(18.0, 9.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0))));
          },
        ),
        SizedBox(
          height: Dimensions.getHeight(30),
        ),
        Container(
          margin: EdgeInsets.only(
            left: Dimensions.getWidth(30),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(text: 'Recommend'),
              SizedBox(
                width: Dimensions.getWidth(10),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: Dimensions.getHeight(3)
                ),
                child: BigText(text: '.', color: Colors.black26,),
              ),
              SizedBox(
                width: Dimensions.getWidth(10),
              ),
              Container(
                  margin: EdgeInsets.only(
                      bottom: Dimensions.getHeight(2)
                  ),
                  child: SmallText(text: 'Food pairing')
              ),
            ],
          ),
        ),
        GetBuilder<RecommendProductController>(builder: (controller) {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.recommendProductList.length,
            itemBuilder: (context, index) {
              return _buildListViewItem(index, controller.recommendProductList[index]);
            },);
          },
        )

      ],
    );
  }

  Widget _buildPageItem(int position, ProductItem item)
  {
    return Transform(
      transform: getTransform(position),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {

              Get.toNamed(RouteHelper.getPopularFood(position, ViewPage.POPULAR_DETAIL));
            },
            child: Container(
              height: Dimensions.getHeight(220),
              margin: EdgeInsets.only(left: Dimensions.getWidth(10), right: Dimensions.getWidth(10)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.getHeight(30)),
                  color: position.isEven? Color(0xFF69c5df) : Color(0xFF9294cc),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          Common.URL_IMAGE_UPLOAD +  item.img!
                      )
                  )
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.getHeight(120),
              margin: EdgeInsets.only(
                  left: Dimensions.getWidth(30),
                  right: Dimensions.getWidth(30),
                  bottom: Dimensions.getHeight(20)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.getHeight(20)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFe8e8e8),
                      blurRadius: 5.0,
                      offset: Offset(2,2)
                    ),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-5,0)
                    ),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(5,0)
                    )

                  ]
              ),
              child: Container(
                padding: EdgeInsets.only(
                    top: Dimensions.getHeight(15),
                    left: Dimensions.getWidth(15),
                    right: Dimensions.getWidth(15)),
                child: FoodInformationView(text: item.name!),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListViewItem(int index, ProductItem item)
  {
    return Container(
      margin: EdgeInsets.only(
          left: Dimensions.getWidth(20),
          right: Dimensions.getWidth(20),
          bottom: Dimensions.getHeight(10)
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteHelper.getRecommendFood(index, ViewPage.RECOMMAND_DETAIL));
            },
            child: Container(
              width: Dimensions.getWidth(120),
              height: Dimensions.getHeight(120),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.getWidth(20)),
                  color: Colors.white38,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                           Common.URL_IMAGE_UPLOAD + item.img!
                      )
                  )
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: Dimensions.getHeight(100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Dimensions.getWidth(20)),
                    bottomRight: Radius.circular(Dimensions.getWidth(20))
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: Dimensions.getWidth(10),
                    right: Dimensions.getWidth(10),
                    top: Dimensions.getHeight(10)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(text: item.name!),
                    SizedBox(
                      height: Dimensions.getHeight(10),
                    ),
                    SmallText(
                        text: item.description!,
                        enableEllipsis: true),
                    SizedBox(
                      height: Dimensions.getHeight(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconText(
                            icon: Icons.circle_sharp,
                            iconSize: Dimensions.getWidth(20),
                            text: 'Normal',
                            textSize: Dimensions.getWidth(10),
                            iconColor: AppColors.yellowColor),
                        IconText(
                            icon: Icons.location_on,
                            iconSize: Dimensions.getWidth(20),
                            text: '1.8km',
                            textSize: Dimensions.getWidth(10),
                            iconColor: AppColors.mainColor),
                        IconText(
                            icon: Icons.access_time_outlined,
                            iconSize: Dimensions.getWidth(20),
                            text: '32min',
                            textSize: Dimensions.getWidth(10),
                            iconColor: AppColors.iconColor2)
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Matrix4 getTransform(int position)
  {
    Matrix4 matrix = new Matrix4.identity();
    if (position == _currentPageValue.floor()) {
      var currentScale = 1 - (_currentPageValue - position) * (1 - _scaleFactor);
      var currentTransition = _scaleHeight * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransition, 0);
    }
    else if (position == _currentPageValue.floor() + 1) {
      var currentScale = _scaleFactor + (_currentPageValue - position + 1) * (1 - _scaleFactor);
      var currentTransition = _scaleHeight * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransition, 0);
    }
    else if (position == _currentPageValue.floor() - 1) {
      var currentScale = 1 - (_currentPageValue - position) * (1 - _scaleFactor);
      var currentTransition = _scaleHeight * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransition, 0);
    }
    else
    {
      var currentScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, _scaleHeight * (1-_scaleFactor)/2, 1);
    }

    return matrix;
  }
}


