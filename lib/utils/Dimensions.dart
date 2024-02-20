import 'package:get/get.dart';

class Dimensions
{
  static double _screenWidth = Get.context!.width;
  static double _screenHeight = Get.context!.height;

  static double getHeight(dynamic size)
  {
    double tempSize = _screenHeight/size;
    return _screenHeight/tempSize;
  }

  static double getWidth(dynamic size)
  {
    double tempSize = _screenWidth/size;
    return _screenWidth/tempSize;
  }
}
