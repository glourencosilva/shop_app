import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_prov.dart';
import 'package:shop_app/screens/auth_screen.dart';

import 'providers/cart_prov.dart';
import 'providers/orders_prov.dart';
import 'providers/products_prov.dart';
import 'screens/chart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/paymant_scree.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_overview.dart';
import 'screens/user_products_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data =
  await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Color primary = const Color(0xFF6750A4);
    // Color primaryContainer = const Color(0xFFEADDFF);
    // Color secondary = const Color(0xFF625B71);
    // Color secondaryContainer = const Color(0xFFE8DEF8);
    // Color tertiary = const Color(0xFF7D5260);

    final ThemeData theme = ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.purple,
      fontFamily: 'Lato',
      // iconTheme: const IconThemeData(
      //   color: Colors.deepOrange,
      // ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProv>(
          create: (context) => AuthProv(),
          //child: const AuthScreen(),
        ),
        ChangeNotifierProxyProvider<AuthProv, ProductProv>(
          create: (context) => ProductProv('', []),
          update: (context, authProv, productProv) => ProductProv(
              authProv.token, productProv == null ? [] :  productProv.items),
        ),
        ChangeNotifierProvider<CartProv>(
          create: (context) => CartProv(),
        ),
        ChangeNotifierProvider<OrdersProv>(
          create: (context) => OrdersProv(),
        ),
      ],
      child: Consumer<AuthProv>(
        builder: (context, authData, child) {
          return MaterialApp(
            title: 'MyShop',
            debugShowCheckedModeBanner: false,
            theme: theme.copyWith(
              colorScheme: theme.colorScheme.copyWith(
                secondary: Colors.deepOrange,
                primary: Colors.purple,
              ),
            ),
            initialRoute: authData.isAuth ? UserProductsScreen.routeName : AuthScreen.routeName,
            routes: {
              ProductOverviewScreen.routeName: (context) =>
                  ProductOverviewScreen(),
              ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
              ChartScreen.routeName: (context) => const ChartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              PaymantScreen.routeName: (context) => const PaymantScreen(),
              UserProductsScreen.routeName: (
                  context) => const UserProductsScreen(),
              EditProductScreen.routeName: (
                  context) => const EditProductScreen(),
              AuthScreen.routeName: (context) => const AuthScreen(),
            },
          );
        },
      ),
    );
  }
}
