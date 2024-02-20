import 'ProductItem.dart';

class Product {
  int? _totalSize;
  int? _typeId;
  int? _offset;
  late List<ProductItem> _products;

  Product({required totalSize, required typeId, required offset, required products})
  {
      this._totalSize = totalSize;
      this._typeId = _typeId;
      this._offset = offset;
      this._products = products;
  }

  List<ProductItem> get productItemList => _products;

  Product.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _typeId = json['type_id'];
    _offset = json['offset'];
    if (json['products'] != null) {
      _products = <ProductItem>[];
      json['products'].forEach((v) {
        _products.add(ProductItem.fromJson(v));
      });
    }
  }


}