import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/cart_item_model.dart';
import '../models/order_item_model.dart';

class OrdersProv with ChangeNotifier {
  late List<OrderItemModel> _orders = [];

  List<OrderItemModel> get orders => [..._orders];

  //final _idOrder = const Uuid().v4();

  Future<void> addOrder(List<CartItemModel> cartProducts, double total) async {
    final dateTime = DateTime.now();
    final url = Uri.https(baseUrlApi, ordersUrlApi);

    final orderMap = <String, dynamic>{
      'amount': total,
      'dataTime': dateTime.toIso8601String(),
      'products': cartProducts.map((cartItemModel) {
        return <String, dynamic>{
          'id': cartItemModel.id,
          'title': cartItemModel.title,
          'quantity': cartItemModel.quantite,
          'price': cartItemModel.price
        };
      }).toList(),
    };

    final response = await http.post(url, body: jsonEncode(orderMap));
    var order = OrderItemModel(
      id: jsonDecode(response.body)['name'],
      amount: total,
      products: cartProducts,
      dateTime: dateTime,
    );
    _orders.insert(0, order);
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(baseUrlApi, ordersUrlApi);
    final response = await http.get(url);

    List<OrderItemModel> loadedOrders = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedData.isEmpty) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      var order = OrderItemModel(
        id: orderId,
        amount: orderData['amount'],
        products: (orderData['products'] as List<dynamic>).map((cartItem) {
          return CartItemModel(
            id: cartItem['id'],
            title: cartItem['title'],
            quantite: cartItem['quantity'],
            price: cartItem['price'],
          );
        }).toList(),
        dateTime: DateTime.parse(orderData['dataTime']),
      );
      loadedOrders.add(order);
    });
    _orders = loadedOrders;
    _orders.reversed.toList();
   // _orders.insert(0, order);
    notifyListeners();
  }

  void printSet(Set<int> ids) => debugPrint('$ids!');

  void printHashSet(LinkedHashSet<int> ids) => printSet(ids);

  void printMap(Map map) => debugPrint('$map!');

  void printHashMap(LinkedHashMap map) => printMap(map);
}
