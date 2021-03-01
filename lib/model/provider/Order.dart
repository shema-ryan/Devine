import 'package:flutter/material.dart';
import '../model.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';

class OrderItem {
  final String id;
  final DateTime date;
  final List<CartItem> cart;
  final double total;

  OrderItem({this.id, this.date, this.cart, this.total});
}

class Order with ChangeNotifier {
  final String token;
  List<OrderItem> _orderItem = [];

  Order(this.token, this._orderItem);
  List<OrderItem> get orderedItem {
    return [..._orderItem];
  }

  Future<void> fetchAndSetOrder() async {
    final url =
        'https://devine-90003-default-rtdb.firebaseio.com/Orders.json?auth=$token';
    try {
      final response = await Http.get(url);
      if (response.statusCode >= 400) {
        throw 'the same';
      } else {
        List<OrderItem> _loadedOrder = [];
        final Map<String, dynamic> _map = json.decode(response.body);
        _map.forEach((key, value) {
          _loadedOrder.insert(
              0,
              OrderItem(
                id: value['id'],
                date: DateTime.parse(value['date']),
                total: value['total'],
                cart: (value['cart'] as List<dynamic>)
                    .map((_cart) => CartItem(
                          id: _cart['id'],
                          title: _cart['title'],
                          price: _cart['price'],
                          quantity: _cart['quantity'],
                        ))
                    .toList(),
              ));
        });
        print(_loadedOrder.length);
        _orderItem = _loadedOrder;
        print('this is the order items :' + _orderItem.length.toString());
        notifyListeners();
      }
    } catch (e) {}
  }

  Future<void> addOrder({OrderItem orderItem}) async {
    final url =
        'https://devine-90003-default-rtdb.firebaseio.com/Orders.json?auth=$token';
    try {
      final response = await Http.post(url,
          body: json.encode({
            'id': orderItem.id,
            'date': orderItem.date.toIso8601String(),
            'total': orderItem.total,
            'cart': orderItem.cart
                .map((_cart) => {
                      'id': _cart.id,
                      'price': _cart.price,
                      'quantity': _cart.quantity,
                      'title': _cart.title,
                    })
                .toList(),
          }));
      if (response.statusCode >= 400) {
        throw 'hallelua';
      }
    } catch (e) {
      throw 'something interesting';
    }
    _orderItem.insert(0, orderItem);
    notifyListeners();
  }
}
