import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  late bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    this.price = 0.0,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory Product.empty() => Product(
        id: '',
        title: '',
        description: '',
        price: 0.0,
        imageUrl: '',
      );

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    //final url = Uri.https(baseUrlApi, '/products/$id.json', {'auth': token});
    final url = Uri.https(baseUrlApi, '/userFavorite/$userId/$id.json', {'auth': token});
    try {
      final response =
          await http.put(url, body: jsonEncode(isFavorite));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } on HttpException catch (e) {
      _setFavValue(oldStatus);
    }
  }

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }
}
