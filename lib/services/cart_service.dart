import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

// Using Singleton pattern to ensure there's only one instance of CartService
class CartService extends ChangeNotifier {
  // Singleton implementation
  static final CartService _instance = CartService._internal();
  
  factory CartService() {
    return _instance;
  }
  
  CartService._internal();
  
  // Private list of cart items
  final List<CartItem> _items = [];
  
  // Getter that returns an unmodifiable view of the items
  List<CartItem> get items => List.unmodifiable(_items);
  
  // Get total number of items, counting quantities
  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }
  
  // Get total number of unique products
  int get uniqueItemCount => _items.length;
  
  // Calculate total amount
  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
  
  // Add a product to the cart
  void addProduct(Product product) {
    // Check if the product is already in the cart
    final existingIndex = _items.indexWhere((item) => item.id == product.id);
    
    if (existingIndex >= 0) {
      // Increase quantity if product already exists
      _items[existingIndex].quantity += 1;
    } else {
      // Add as new item
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
    
    notifyListeners();
  }
  
  // Add a cart item directly
  void addItem(CartItem item) {
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
  
  // Update quantity of an item
  void updateQuantity(String id, int quantity) {
    final index = _items.indexWhere((item) => item.id == id);
    
    if (index >= 0) {
      if (quantity <= 0) {
        // Remove item if quantity becomes zero or negative
        _items.removeAt(index);
      } else {
        // Update quantity
        _items[index].quantity = quantity;
      }
      
      notifyListeners();
    }
  }
  
  // Remove an item from the cart
  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
  
  // Clear the cart
  void clear() {
    _items.clear();
    notifyListeners();
  }
}