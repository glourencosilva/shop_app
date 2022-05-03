import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_prov.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItemWidget extends StatelessWidget {
  const UserProductItemWidget(
      {Key? key,
      required this.id,
      required this.title,
      required this.imageUrl,
      this.deleteHandle})
      : super(key: key);

  final String id;
  final String title;
  final String imageUrl;
  final Function? deleteHandle;

  @override
  Widget build(BuildContext context) {
    //final prod = Provider.of<ProductProv>(context, listen: false);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                var prodId = Provider.of<ProductProv>(context, listen: false).findById(id);
                if (prodId.id.isNotEmpty) {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName,
                      arguments: prodId.id);
                } else {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                }
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                //var prodId = prod.findById(id);
                try {
                  await Provider.of<ProductProv>(context, listen: false).deleteProduct(id);
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Deleting failed!'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
