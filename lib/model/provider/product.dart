import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as Http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite = false;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavorite(String token) {
    final url =
        'https://devine-90003-default-rtdb.firebaseio.com/Products/$id.json?auth=$token';
    bool oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    return Http.patch(url, body: json.encode({'isFavorite': isFavorite}))
        .then((value) {
      if (value.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    });
  }
}
