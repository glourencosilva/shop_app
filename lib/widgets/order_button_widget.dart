import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_prov.dart';
import 'package:shop_app/providers/orders_prov.dart';
import 'package:shop_app/screens/orders_screen.dart';

class OrderButtonWidget extends StatefulWidget {
  const OrderButtonWidget({
    Key? key,
    required this.cart,
    required this.orders,
  }) : super(key: key);

  final CartProv cart;
  final OrdersProv orders;

  @override
  State<OrderButtonWidget> createState() => _OrderButtonWidgetState();
}

class _OrderButtonWidgetState extends State<OrderButtonWidget> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await widget.orders.addOrder(
                  widget.cart.itensCart.values.toList(),
                  widget.cart.totalAmount);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const Text('Order Now'),
    );
  }
}
