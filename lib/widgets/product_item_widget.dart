import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_prov.dart';
import 'package:shop_app/providers/cart_prov.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({
    Key? key,
    // required this.id,
    // required this.title,
    // required this.imageUrl,
  }) : super(key: key);

  // final String id;
  // final String title;
  // final String imageUrl;

  @override
  Widget build(BuildContext context) {
    debugPrint('Rebuild widget');
    final productProvider = Provider.of<Product>(context, listen: true);
    final cartProvider = Provider.of<CartProv>(context, listen: false);
    final authData = Provider.of<AuthProv>(context, listen: false);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8.0),
        topRight: Radius.circular(8.0),
        bottomLeft: Radius.circular(5.0),
        bottomRight: Radius.circular(5.0),
      ),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            // final router = MaterialPageRoute(builder: (context) {
            //   return ProductDetailScreen(title: title,);
            // });
            // Navigator.of(context).push(router);
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: {
                  'id': productProvider.id,
                  'title': productProvider.title
                });
          },
          child: Image.network(
            productProvider.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (context, product, _) => IconButton(
              onPressed: () {
                product.toggleFavoriteStatus(authData.token, authData.userId);
              },
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cartProvider.addItem(productProvider.id, productProvider.price,
                  productProvider.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Added item to cart!',
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () =>
                          cartProvider.removeItem(productProvider.id)),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(productProvider.title, textAlign: TextAlign.center),
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }
}
