import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_prov.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/user_product_item_widget.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  static const String routeName = '/user-products-screen';

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<ProductProv>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
          future: _refreshProduct(context),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProduct(context),
                    child: Consumer<ProductProv>(
                      builder: (context, productProv, child) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: productProv.items.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  UserProductItemWidget(
                                    id: productProv.items[index].id,
                                    title: productProv.items[index].title,
                                    imageUrl: productProv.items[index].imageUrl,
                                  ),
                                  const Divider(),
                                ],
                              );
                            }),
                      ),
                    ),
                  );
          }),
    );
  }

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<ProductProv>(context, listen: false)
        .fetchAndSetProducts(true);
  }
}
