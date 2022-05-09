import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class ProductProv with ChangeNotifier {
  ProductProv(this.authToken, this._items);

  //this.authToken, this._items
  late List<Product> _items = [];

  final String authToken;

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    final queryParams = <String, dynamic>{'auth': authToken};
    final url = Uri.https(baseUrlApi, productUrlApi, queryParams);
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          // isFavorite:
          // favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } on Exception catch (e) {
      throw Exception(e);
    }

    // try {
    //   await http.get(url).then((productResponse) {
    //
    //     final extractData =
    //         jsonDecode(productResponse.body) as Map<String, dynamic>;
    //     final List<Product> loadedProducts = [];
    //     extractData.forEach((prodId, productData) {
    //       var product = Product(
    //           id: prodId,
    //           title: productData['title'] as String,
    //           description: productData['description'] as String,
    //           imageUrl: productData['imageUrl'] as String,
    //           price: productData['price'] as double,
    //           isFavorite: productData['isFavorite'] as bool);
    //       loadedProducts.add(product);
    //
    //       _items = loadedProducts;
    //       notifyListeners();
    //     });
    //   });
    // } on Exception catch (e) {
    //   //throw Exception('Erro ai pegar dados do servidor remoto');
    //   throw Exception(e);
    // }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https(baseUrlApi, productUrlApi);

    var nProduct = <String, dynamic>{
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavorite': product.isFavorite,
    };

    try {
      await http.post(url, body: jsonEncode(nProduct)).then((response) {
        var uuid = jsonDecode(response.body) as Map<String, dynamic>;

        final newProduct = Product(
          id: uuid['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          isFavorite: product.isFavorite,
        );
        _items.insert(0, newProduct);
        notifyListeners();
      });
    } on Exception catch (e) {
      throw Exception('Deu ruim');
    }

    //_items.add(newProduct);
  }

  Product findById(String id) {
    final prod = _items.firstWhere((prod) => prod.id == id);
    return prod;
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url = Uri.https(baseUrlApi, '/products/$id.json');

      var product = {
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
        'isFavorite': newProduct.isFavorite,
      };
      var productJson = jsonEncode(product);
      await http.patch(
        url,
        body: productJson,
      );
      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https(baseUrlApi, '/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = Product.empty();
  }
}
