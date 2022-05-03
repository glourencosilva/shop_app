import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_prov.dart';
import 'package:shop_app/widgets/product_item_widget.dart';

class ProductGrid extends StatelessWidget{
  const ProductGrid( {
    Key? key, required this.showFavoritesOnly,
    //required this.loadedProducts,
  }) : super(key: key);

  final bool showFavoritesOnly;

  //final List<Product>? loadedProducts;

  @override
  Widget build(BuildContext context) {
    final providerProductGrid = Provider.of<ProductProv>(context);
    final products =  showFavoritesOnly ? providerProductGrid.favoriteItems : providerProductGrid.items;
    return products.isNotEmpty ? GridView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          //builder: (context, widget)=> products[index] as Widget,
          child:  const ProductItemWidget(
              // id: products[index].id,
              // title: products[index].title,
              // imageUrl: products[index].imageUrl,
              ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          //childAspectRatio: 3 / 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5),
    ) : const Center(child: CircularProgressIndicator(),);
  }
}
