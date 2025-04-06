import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  void addToCart(CartItem item) {
    // Cek apakah item sudah ada di keranjang
    for (var existingItem in _items) {
      if (existingItem.id == item.id) {
        existingItem.quantity += item.quantity;
        notifyListeners();
        return;
      }
    }
    
    // Jika item belum ada, tambahkan item baru
    _items.add(item);
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int newQuantity) {
    final index = _items.indexWhere((cartItem) => cartItem.id == item.id);
    if (index != -1) {
      if (newQuantity > 0) {
        _items[index].quantity = newQuantity;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalAmount => 
    _items.fold(0.0, (total, current) => total + (current.price * current.quantity));
}