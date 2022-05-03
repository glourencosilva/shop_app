import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_prov.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const String routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersProv>(context, listen: false);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
        //   automaticallyImplyLeading: false,
        //   leading: IconButton(
        //       onPressed: () {
        //         Navigator.of(context)
        //             .popAndPushNamed(ProductOverviewScreen.routeName);
        //       },
        //       icon: const Icon(Icons.arrow_back)),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (context, index) {
          return OrderItem(
            orderItem: orderData.orders[index],
          );
        },
      ),
    );
  }
}
