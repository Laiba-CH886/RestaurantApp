import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/food_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  int get itemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return _cartItems.fold(0.0, (total, item) => total + (item.price * item.quantity));
  }

  void addItem(FoodItem foodItem, {int quantity = 1}) {
    int index = _cartItems.indexWhere((item) => item.id == foodItem.id);

    if (index != -1) {
      // Item exists, increase quantity
      _cartItems[index] = _cartItems[index].copyWith(quantity: _cartItems[index].quantity + quantity);
    } else {
      // New item, add to cart
      _cartItems.add(foodItem.toCartItem(quantity)); // Use the toCartItem function which includes the food item.
    }

    notifyListeners();
  }

  void removeItem(String itemId, {bool removeAll = false}) {
    int index = _cartItems.indexWhere((item) => item.id == itemId);

    if (index != -1) {
      if (removeAll || _cartItems[index].quantity <= 1) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: _cartItems[index].quantity - 1);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}