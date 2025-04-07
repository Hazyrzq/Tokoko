import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Get total number of items, counting quantities
  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get total number of unique products
  int get uniqueItemCount => _items.length;

  void addToCart(CartItem item) {
    // Check if item already exists in cart
    final existingIndex = _items.indexWhere((cartItem) => cartItem.id == item.id);
    
    if (existingIndex >= 0) {
      // Update existing item quantity
      _items[existingIndex].quantity += item.quantity;
    } else {
      // Add new item
      _items.add(item);
    }
    
    notifyListeners();
  }

  void removeFromCart(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int newQuantity) {
    final index = _items.indexWhere((cartItem) => cartItem.id == id);
    
    if (index >= 0) {
      if (newQuantity > 0) {
        _items[index].quantity = newQuantity;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get totalAmount => 
    _items.fold(0.0, (total, current) => total + (current.price * current.quantity));
}