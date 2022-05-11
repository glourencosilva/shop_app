import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shop_app/providers/auth_prov.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';

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
        ChangeNotifierProvider.value(
          value: AuthProv(),
          child: const AuthScreen(),
        ),
        ChangeNotifierProxyProvider<AuthProv, ProductProv>(
          create: (context) => ProductProv('', [], ''),
          update: (context, authProv, productProv) => ProductProv(
              authProv.token,
              productProv == null ? [] : productProv.items,
              authProv.userId),
        ),
        ChangeNotifierProvider<CartProv>(
          create: (context) => CartProv(),
        ),
        ChangeNotifierProxyProvider<AuthProv, OrdersProv>(
          create: (context) => OrdersProv('', [], ''),
          update: (context, authProv, ordersProv) => OrdersProv(
              authProv.token,
              ordersProv == null ? [] : ordersProv.orders,
              authProv.userId
          ),
        ),
      ],
      child: Consumer<AuthProv>(
        builder: (context, authData, child) {
          return MaterialApp(
            title: 'MyShop',
            debugShowCheckedModeBanner: false,
            builder: (context, widget) => ResponsiveWrapper.builder(
                BouncingScrollWrapper.builder(context, widget!),
                maxWidth: 6460,
                minWidth: 450,
                defaultScale: true,
                breakpoints: [
                  const ResponsiveBreakpoint.resize(450, name: MOBILE),
                  const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                  const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                  const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                  const ResponsiveBreakpoint.autoScale(6460, name: "4K"),
                ],
                background: Container(color: const Color(0xFFF5F5F5))),
            theme: theme.copyWith(
              colorScheme: theme.colorScheme.copyWith(
                secondary: Colors.deepOrange,
                primary: Colors.purple,
              ),
            ),
            home: authData.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                future: authData.tryAutoLogin(),
                builder: (context, authResultSnapshot)=> authResultSnapshot.connectionState == ConnectionState.waiting ? const SplashScreen() : const AuthScreen()),
            routes: {
              ProductOverviewScreen.routeName: (context) =>
                  ProductOverviewScreen(),
              ProductDetailScreen.routeName: (context) =>
                  const ProductDetailScreen(),
              ChartScreen.routeName: (context) => const ChartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              PaymantScreen.routeName: (context) => const PaymantScreen(),
              UserProductsScreen.routeName: (context) =>
                  const UserProductsScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
              AuthScreen.routeName: (context) => const AuthScreen(),
            },
          );
        },
      ),
    );
  }
}
