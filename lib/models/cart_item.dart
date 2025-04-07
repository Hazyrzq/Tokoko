class CartItem {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final String imageUrl;
  int quantity;
 
  CartItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}