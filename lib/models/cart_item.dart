// File: lib/models/cart_item.dart

class CartItem {
  final int id;
  final String name;
  final int price;
  int quantity;
  final String imageUrl;
  final String subtitle;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.subtitle,
  });
}