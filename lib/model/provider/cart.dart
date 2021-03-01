import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartData = {};
  Map<String, CartItem> get cartData {
    return {..._cartData};
  }

  int get cartItemCount {
    return _cartData.length;
  }

  double get totalAmount {
    var total = 0.0;
    _cartData.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addCartItem({String productId, CartItem cartItem}) {
    if (_cartData.containsKey(productId)) {
      _cartData.update(
          productId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              quantity: value.quantity + 1,
              price: value.price));
    } else {
      _cartData.putIfAbsent(productId, () => cartItem);
    }
    notifyListeners();
  }

  void removeItem({String productId}) {
    _cartData.remove(productId);
    notifyListeners();
  }

  void undoAddItem({String productId}) {
    if (!_cartData.containsKey(productId)) {
      return;
    } else if (_cartData[productId].quantity > 1) {
      _cartData.update(
          productId,
          (value) => CartItem(
                id: value.id,
                title: value.title,
                quantity: value.quantity - 1,
                price: value.price,
              ));
    } else {
      _cartData.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartData.clear();
    notifyListeners();
  }
}
