import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_prov.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../providers/cart_prov.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import 'chart_screen.dart';

// ignore: must_be_immutable
class ProductOverviewScreen extends StatefulWidget {
  ProductOverviewScreen({Key? key}) : super(key: key);

  static const String routeName = '/product-overview-screen';
  late bool _showFavoritesOnly = false;
  late bool _isInit = true;
  late bool _isLoading = false;

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {


  @override
  Widget build(BuildContext context) {
    // final cartProv = Provider.of<CartProv>(context, listen: false);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          Consumer<CartProv>(
            builder: (context, cart, child) {
              return Badge(child: child!, value: cart.itemCount.toString());
            },
            child: context.select<CartProv, int>((value) => value.itemCount) > 0
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(ChartScreen.routeName);
                    },
                    icon: const Icon(Icons.shopping_cart),
                    //color: Theme.of(context).colorScheme.secondary,
                  )
                : const SizedBox.shrink(),
          ),
          PopupMenuButton(
            color: Theme.of(context).colorScheme.secondary,
            elevation: 2.0,
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  widget._showFavoritesOnly = true;
                } else {
                  widget._showFavoritesOnly = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                  child: Text(
                    'Only Favorites',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: FilterOptions.favorites),
              const PopupMenuItem(
                  child:
                      Text('Show All', style: TextStyle(color: Colors.white)),
                  value: FilterOptions.all),
            ],
          ),
        ],
      ),
      body: widget._isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showFavoritesOnly: widget._showFavoritesOnly),
    );
  }

  @override
  void initState() {
    context.read<ProductProv>().fetchAndSetProducts();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget._isInit) {
      setState(() {
        widget._isLoading = true;
      });

      context
          .read<ProductProv>()
          .fetchAndSetProducts()
          .then((_) => widget._isLoading = false);
    }
    setState(() {
      widget._isLoading = false;
    });
    widget._isInit = false;

    super.didChangeDependencies();
  }
}

enum FilterOptions {
  favorites,
  all,
}
