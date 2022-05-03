import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/cart_item_model.dart';

class CartProv with ChangeNotifier {
  late Map<String, CartItemModel> _itens = {};

  Map<String, CartItemModel> get itensCart {
    return {..._itens};
  }

  int get itemCount {
    return _itens.length;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_itens.containsKey(productId)) {
      _itens.update(productId, (existingCartItem) {
        var item = CartItemModel(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantite: existingCartItem.quantite + 1,
        );
        return item;
      });
    } else {
      var item = CartItemModel(
        id: const Uuid().v4(),
        title: title,
        price: price,
        quantite: 1,
      );
      _itens.putIfAbsent(productId, () => item);
    }
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _itens.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantite;
    });

    return total;
  }

  void removeItem(String productId) {
    _itens.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    if (_itens.isNotEmpty) {
      _itens = {};
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (_itens.containsKey(productId)) {
      return;
    }
    if (_itens[productId]!.quantite > 1) {
      _itens.update(
          productId,
          (cim) => CartItemModel(
                id: cim.id,
                title: cim.title,
                quantite: cim.quantite - 1,
                price: cim.price,
              ));
    } else {
      _itens.remove(productId);
    }
    notifyListeners();
  }
}
