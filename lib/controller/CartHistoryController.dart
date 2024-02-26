import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:food_delivery/repository/CartHistoryRepository.dart';
import 'package:get/get.dart';

import '../common/CommonUtils.dart';
import '../data/result/CartItem.dart';

class CartHistoryController extends GetxController
{
  List<CartItem>? cartHistoryList = null;
  late List<int> itemsPerOrderCountList;
  late List<String> itemsPerOrderTimeList;


  final CartHistoryRepository cartHistoryRepository;
  CartHistoryController({required this.cartHistoryRepository});

  Future<void> getCartHistoryList() async
  {
    Logger.d("getCartHistoryList request");
    cartHistoryList = null;
    cartHistoryList = await cartHistoryRepository.getCartHistoryList();

    Logger.d("getCartHistoryList complete");
    cartHistoryList = cartHistoryList!.reversed.toList();
    Map<String, int> cartItemsPerOrder = CommonUtils.getInstance().getPerOrderForCartItems(cartHistoryList!);
    itemsPerOrderCountList = cartItemsPerOrder.entries.map((e) => e.value).toList();
    itemsPerOrderTimeList = cartItemsPerOrder.entries.map((e) => e.key).toList();
    update();
  }
}