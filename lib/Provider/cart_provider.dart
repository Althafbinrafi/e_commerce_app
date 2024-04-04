import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  final List<CartProduct> _list = [];
  List<CartProduct> get getItems {
    return _list;
  }

  double get totalPrice {
    var total = 0.0;

    for (var item in _list) {
      double price = double.parse(item.price);
      total += price * item.qty;
    }
    return total;
  }

  int? get count {
    return _list.length;
  }

  void addItem(
    int id,
    String name,
    double price,
    int qty,
    String imageUrl,
  ) {
    final product = CartProduct(
        id: id,
        imageUrl: imageUrl,
        name: name,
        price: price.toString(),
        qty: qty);
    _list.add(product);
    notifyListeners();
  }

  void increment(CartProduct product) {
    product.increase();
    notifyListeners();
  }

  void reduceByOne(CartProduct product) {
    product.decrease();
    notifyListeners();
  }

  void removeItems(CartProduct product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }
}

class CartProduct {
  int id;
  String name;
  String price;
  int qty = 1;
  String imageUrl;

  CartProduct({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.qty,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        id: json["id"],
        name: json["catid"],
        imageUrl: json["productname"],
        price: json["price"].toString(),
        qty: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "qty": qty,
        "price": price,
        "image": imageUrl,
      };

  void increase() {
    qty++;
  }

  void decrease() {
    qty--;
  }
}
