// File: lib/models/product.dart

class Product {
  final int id;
  final String name;
  final int price;
  final String imageUrl;
  final String subtitle;
  
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.subtitle,
  });
}