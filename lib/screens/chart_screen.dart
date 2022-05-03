import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/order_button_widget.dart';
import '../providers/orders_prov.dart';
import 'orders_screen.dart';
import '../widgets/cart_item.dart';

import '../providers/cart_prov.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({Key? key}) : super(key: key);

  static const String routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProv>(context);
    final orders = Provider.of<OrdersProv>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .titleSmall!
                                .color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButtonWidget(cart: cart, orders: orders),
                  ],
                )),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, index) {
                var result = cart.itensCart.values.toList()[index];
                return CartItem(
                  id: result.id,
                  price: result.price,
                  quantity: result.quantite,
                  title: result.title,
                  productId: cart.itensCart.keys.toList()[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


