import '../result/ProductItem.dart';

class CheckoutItem
{
  List<ProductItem> itemList = [];

  CheckoutItem({required this.itemList});

  Map<String, dynamic> toJson()
  {
    return {
      'itemList': itemList.map((product) => product.toJson()).toList()
    };
  }

  factory CheckoutItem.fromJson(Map<String, dynamic> data)
  {
    var list = data['itemList'].map((e) => ProductItem.fromJson(e)).toList();
    return CheckoutItem(
        itemList: List<ProductItem>.from(list));
  }
}