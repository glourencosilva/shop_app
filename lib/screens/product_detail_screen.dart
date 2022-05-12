import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_prov.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    Key? key,
    //required this.title,
  }) : super(key: key);

  // final String title;

  static const String routeName = 'product-detail-screen';

  @override
  Widget build(BuildContext context) {
    final routerArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final loadedProduct = Provider.of<ProductProv>(context, listen: false);
    //final productId = productProvider.items.firstWhere((prod) => prod.id == routerArg['id']);
    final productId = loadedProduct.findById(routerArg['id']);

    final title = productId.title;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black12,
            iconTheme: const IconThemeData(color: Colors.black),
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title),
              background: Hero(
                tag: loadedProduct.items.first.id,
                child: Image.network(
                  productId.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'R\$ ${productId.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    productId.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                const SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
