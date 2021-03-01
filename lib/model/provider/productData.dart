import 'dart:convert';
import 'package:flutter/material.dart';
import '../model.dart';
import 'package:http/http.dart' as Http;

class ProductData with ChangeNotifier {
  final String token;
  List<Product> _products = [];
  ProductData(this.token, this._products);

  List<Product> get loadedProduct {
    return [..._products];
  }

  List<Product> get filterProducts {
    return [..._products.where((prodItem) => prodItem.isFavorite)];
  }

  Future<void> addProduct(Product product) async {
    final String url =
        'https://devine-90003-default-rtdb.firebaseio.com/Products.json?auth=$token';
    try {
      final value = await Http.post(url,
          body: jsonEncode({
            'title': product.title,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'description': product.description,
            'isFavorite': product.isFavorite
          }));
      _products.insert(
          0,
          Product(
              imageUrl: product.imageUrl,
              description: product.description,
              id: json.decode(value.body)['name'],
              title: product.title,
              price: product.price));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final url =
        'https://devine-90003-default-rtdb.firebaseio.com/Products/$id.json?auth=$token';
    final response = await Http.patch(url,
        body: json.encode({
          'description': product.description,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
          'price': product.price,
          'title': product.title,
        }));
    print('here it is ' + '${response.statusCode}');
    if (response.statusCode >= 400) {
      throw 'something happened';
    }
    int index = _products.indexWhere((element) => element.id == id);
    _products[index] = product;
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    final url =
        'https://devine-90003-default-rtdb.firebaseio.com/Products/$id.json?auth=$token';
    //optimised delete
    final productIndex = _products.indexWhere((element) => element.id == id);
    Product copy = _products[productIndex];
    _products.removeAt(productIndex);
    notifyListeners();
    final response = await Http.delete(url);
    if (response.statusCode >= 400) {
      _products.insert(productIndex, copy);
      notifyListeners();
      throw '';
    }
    copy = null;
  }

  Future<void> fetchAndSetProduct() async {
    final String url =
        'https://devine-90003-default-rtdb.firebaseio.com/Products.json?auth=$token';
    try {
      final response = await Http.get(url);
      final Map<String, dynamic> _map = json.decode(response.body);
      final List<Product> loadedProduct = [];
      _map.forEach((prodId, prodMap) {
        loadedProduct.add(Product(
            price: prodMap['price'],
            title: prodMap['title'],
            id: prodId,
            description: prodMap['description'],
            imageUrl: prodMap['imageUrl'],
            isFavorite: prodMap['isFavorite']));
      });
      _products = loadedProduct.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
