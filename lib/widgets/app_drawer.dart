import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_prov.dart';
import 'package:shop_app/screens/auth_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/paymant_scree.dart';
import '../screens/products_overview.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text('Hello Friend!'),
          ),
          //const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductOverviewScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Paymant'),
            onTap: () {
              Navigator.of(context).pushNamed(PaymantScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushNamed(UserProductsScreen.routeName);
              Scaffold.of(context).hasEndDrawer;
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.of(context).pushNamed(AuthScreen.routeName);
              // Scaffold.of(context).hasEndDrawer;
              Provider.of<AuthProv>(context, listen: false).logout()
                .then((_) => Navigator.of(context).popAndPushNamed(AuthScreen.routeName));
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pushNamed(ProductOverviewScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
