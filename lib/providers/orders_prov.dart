import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/cart_item_model.dart';
import '../models/order_item_model.dart';

class OrdersProv with ChangeNotifier {
  final List<OrderItemModel> _orders = [];

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
}
