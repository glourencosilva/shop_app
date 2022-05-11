import 'package:equatable/equatable.dart';
import 'package:shop_app/providers/product.dart';

class CartItemModel extends Equatable{
  final String id;
  final String title;
  final int quantite;
  final double price;

  const CartItemModel({
    required this.id,
    required this.title,
    required this.quantite,
    required this.price,
  });

  @override
  List<Object?> get props => [id, title, quantite, price];
}
