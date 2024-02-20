import 'package:get/get.dart';

class LoadingController extends GetxController
{
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    isLoading = false;
  }

  void enable()
  {
    isLoading = true;
    update();
  }

  void disable()
  {
    isLoading = false;
    update();
  }
}