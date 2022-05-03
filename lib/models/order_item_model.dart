import 'package:equatable/equatable.dart';

import 'cart_item_model.dart';

class OrderItemModel extends Equatable {
  final String id;
  final double amount;
  final List<CartItemModel> products;
  final DateTime dateTime;

  const OrderItemModel(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});

  @override
  List<Object?> get props => [id, amount, products, dateTime];
}
