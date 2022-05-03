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
    //final orderData = Provider.of<OrdersProv>(context, listen: false);
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
      body: FutureBuilder(
        //initialData: false,
        future:
            Provider.of<OrdersProv>(context, listen: false).fetchAndSetOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<OrdersProv>(
              builder: (context, orderData, _) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (context, index) {
                  return OrderItem(
                    orderItem: orderData.orders[index],
                  );
                },
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return const Center(child: Text('No data!'));
          } else {
            return snapshot.error != null
                ? const Center(child: Text('Erro!'))
                : const SizedBox.shrink();
          }
        },
      ), /* _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (context, index) {
                return OrderItem(
                  orderItem: orderData.orders[index],
                );
              },
            ),*/
    );
  }
}
