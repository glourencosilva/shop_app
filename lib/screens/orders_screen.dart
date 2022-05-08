import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_prov.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const String routeName = '/orders-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<void> _ordersFuture;

  Future<void> obtainOrdersFuture() async {
    return await Provider.of<OrdersProv>(context, listen: false)
        .fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<OrdersProv>(context, listen: false);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: _ordersFuture,
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
      ),
    );
  }
}
