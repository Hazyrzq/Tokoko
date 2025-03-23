// File: lib/services/cart_service.dart

import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartService extends ChangeNotifier {
  // Singleton pattern
  static final CartService _instance = CartService._internal();
  
  factory CartService() {
    return _instance;
  }
  
  CartService._internal();
  
  // Daftar item di keranjang
  final List<CartItem> _items = [];
  
  // Getter untuk mendapatkan semua item di keranjang
  List<CartItem> get items => _items;
  
  // Getter untuk mendapatkan jumlah total item di keranjang
  int get itemCount => _items.length;
  
  // Getter untuk menghitung total harga
  int get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
  
  // Menambahkan produk ke keranjang
  void addProduct(Product product) {
    // Cek apakah produk sudah ada di keranjang
    final existingIndex = _items.indexWhere((item) => item.id == product.id);
    
    if (existingIndex >= 0) {
      // Jika sudah ada, tambahkan quantity
      _items[existingIndex].quantity += 1;
    } else {
      // Jika belum ada, tambahkan sebagai item baru
      _items.add(
        CartItem(
          id: product.id,
          name: product.name,
          price: product.price,
          quantity: 1,
          imageUrl: product.imageUrl,
          subtitle: product.subtitle,
        ),
      );
    }
    
    // Beritahu listeners bahwa data telah berubah
    notifyListeners();
  }
  
  // Mengubah jumlah item
  void updateQuantity(int id, int quantity) {
    final index = _items.indexWhere((item) => item.id == id);
    
    if (index >= 0) {
      if (quantity <= 0) {
        // Jika quantity 0 atau kurang, hapus item
        _items.removeAt(index);
      } else {
        // Update quantity
        _items[index].quantity = quantity;
      }
      
      notifyListeners();
    }
  }
  
  // Menghapus item dari keranjang
  void removeItem(int id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
  
  // Mengosongkan keranjang
  void clear() {
    _items.clear();
    notifyListeners();
  }
}