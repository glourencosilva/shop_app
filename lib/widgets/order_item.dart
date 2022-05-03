import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/order_item_model.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    Key? key,
    // required this.amounnt,
    // required this.dateOrder,
    required this.orderItem,
  }) : super(key: key);
  // final double amounnt;
  // final DateTime dateOrder;
  final OrderItemModel orderItem;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('R\$ ${widget.orderItem.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              'Data: ${DateFormat('dd/MM/yyyy').format(widget.orderItem.dateTime)}\nTime: ${DateFormat('HH:mm:ss').format(widget.orderItem.dateTime)}',
            ),
            trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: _expanded
                    ? const Icon(Icons.expand_less)
                    : const Icon(Icons.expand_more)),
          ),
          if (_expanded) const Divider(),
          if (_expanded)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
              child: SizedBox(
                height: min(widget.orderItem.products.length * 20.0 + 10, 180),
                child: ListView(
                  shrinkWrap: true,
                  children: widget.orderItem.products.map((prod) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          prod.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${prod.quantite} X R\$ ${prod.price}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
