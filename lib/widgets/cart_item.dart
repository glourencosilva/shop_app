import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_prov.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
    required this.productId,
  }) : super(key: key);

  final String id;
  final double price;
  final int quantity;
  final String title;
  final String productId;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProv>(context, listen: false);
    return Dismissible(
      key: ValueKey<String>(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: Card(
        //margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: Chip(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                elevation: 2,
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                label: Text(
                  'R\$ ${price.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(context).primaryTextTheme.titleSmall!.color),
                )),
            title: Text(title),
            subtitle: Text('Total R\$ ${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        provider.removeItem(productId);
      },
      confirmDismiss: (direction) async {
        return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Are you sure?'),
                content:
                    const Text('Do you want to remove the item from the cart?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('No')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Yes')),
                ],
              );
            });
      },
    );
  }
}
