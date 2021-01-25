import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/cart.dart';
import 'package:mosques_donation_app/services/http_service.dart';

class CartProvider with ChangeNotifier {
  List<Cart> cart = [];
  int cartCount = 0;

  void setCartCount(int count) {
    this.cartCount = count;
  }

  int getCartCount() {
    return cartCount;
  }

  Cart getCartByCategory(Cart oldCart) {
    return cart.where((c) => c.id == oldCart.id).isNotEmpty
        ? cart.firstWhere((c) => c.id == oldCart.id)
        : Cart(
            count: 0,
            id: oldCart.id,
            total: 0,
            products: [],
            name: oldCart.name,
          );
  }

  Future getUserCart(String userId) async {
    cart.clear();
    await HttpService.getUserCart(userId).then((c) {
      c.forEach((ca) {
        if (ca.count != 0) {
          cart.add(ca);
        }
      });
      print(c);
      notifyListeners();
    });
  }

  Future getUserCartCount(String userId) async {
    await HttpService.getCartCount(userId).then((count) {
      this.cartCount = count;
      print(count);
      notifyListeners();
    });
  }
}
