import 'package:flutter/material.dart';
import '../widgets/cart_badge.dart';
import '../services/cart_service.dart';
import '../models/product.dart';

class DetailPromoScreen extends StatefulWidget {
  const DetailPromoScreen({Key? key}) : super(key: key);

  @override
  State<DetailPromoScreen> createState() => _DetailPromoScreenState();
}

class _DetailPromoScreenState extends State<DetailPromoScreen> {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Promo',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          // Tombol keranjang dengan badge
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: CartBadge(
                child: const Icon(Icons.shopping_cart, color: Colors.black54),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Promo dengan Gambar Indomie dan Teks
                  AspectRatio(
                    aspectRatio: 25/9,
                    child: Image.asset(
                      'assets/images/banner4.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.orange,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'SPECIAL PRICE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'KEMASAN KARTON',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'HARGA SPESIAL',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'RP113.700/CTN',
                                        style: TextStyle(
                                          color: Color(0xFF8B4513),
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '*S&K Berlaku',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/images/indomie.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Deskripsi Promo
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Belanja senilai Rp128.000 Indomie Mie Goreng Plus Special Pck 80g diskon Rp12.800',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Periode
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.grey[500], size: 24),
                            const SizedBox(width: 16),
                            Text(
                              'Periode',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              '20 Mar 2025 - 2 Apr 2025',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Minimum Transaksi
                        Row(
                          children: [
                            Icon(Icons.person_outline, color: Colors.grey[500], size: 24),
                            const SizedBox(width: 16),
                            Text(
                              'Minimum Transaksi',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'Rp128.000',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Syarat Dan Ketentuan
                        Row(
                          children: [
                            Icon(Icons.assignment_outlined, color: Colors.grey[500], size: 24),
                            const SizedBox(width: 16),
                            Text(
                              'Syarat Dan Ketentuan',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Selengkapnya',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.blue[600],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        const Divider(height: 1),
                        const SizedBox(height: 24),
                        
                        // Daftar Produk Promo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Daftar Produk Promo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Tampilan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                        child: const Icon(Icons.grid_view, color: Colors.white, size: 18),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(Icons.view_list, color: Colors.grey, size: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // 1 Produk text
                        Row(
                          children: const [
                            Text(
                              '1 Produk',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Product Card
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image and Add button
                              Stack(
                                children: [
                                  // Product Image
                                  SizedBox(
                                    height: 180,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                      child: Image.asset(
                                        'assets/images/indomie_pack.png',
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/indomie.png',
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.white,
                                                child: Center(
                                                  child: Image.asset(
                                                    'assets/images/logo_indomie.png',
                                                    width: 150,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return const Icon(
                                                        Icons.fastfood,
                                                        size: 80,
                                                        color: Colors.amber,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  
                                  // Add Button dengan fungsi tambah ke keranjang
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: InkWell(
                                      onTap: () {
                                        final product = Product(
                                          id: '1',
                                          name: 'Indomie Mi Instan Goreng Plus Special 80g',
                                          price: 3200.0,
                                          imageUrl: 'assets/images/indomie_pack.png',
                                          subtitle: '80g',
                                          rating: 4.8,
                                        );
                                        
                                        // Tambah ke keranjang
                                        _cartService.addProduct(product);
                                        
                                        // Refresh UI
                                        setState(() {});
                                        
                                        // Tampilkan notifikasi
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Produk telah ditambahkan ke keranjang'),
                                            duration: const Duration(seconds: 2),
                                            action: SnackBarAction(
                                              label: 'LIHAT',
                                              onPressed: () {
                                                Navigator.pushNamed(context, '/cart');
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              // Special Price Badge - Yellow Blue
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade300,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(32),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'Mie Instant Mi Goreng',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '80g',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Special Price Badge - Red
                              Container(
                                width: double.infinity,
                                color: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                child: const Text(
                                  'HARGA SPESIAL KARTON',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              
                              // Price Badge - Red
                              Container(
                                width: double.infinity,
                                color: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                child: const Text(
                                  'RP 113.700',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              
                              // Product Details
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Indomie Mi Instan Goreng Plus Special 80g',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Rp3.200',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade100,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'Paket Bundling',
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Banyak Lebih Hemat',
                                      style: TextStyle(
                                        color: Colors.red.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Tambah tombol "Tambah ke Keranjang" seperti di FoodCategoryScreen
                                    InkWell(
                                      onTap: () {
                                        // Buat objek Product 
                                        final product = Product(
                                          id: '1',
                                          name: 'Indomie Mi Instan Goreng Plus Special 80g',
                                          price: 3200.0,
                                          imageUrl: 'assets/images/indomie_pack.png',
                                          subtitle: '80g',
                                          rating: 4.8,
                                        );
                                        
                                        // Tambah ke keranjang
                                        _cartService.addProduct(product);
                                        
                                        // Refresh UI
                                        setState(() {});
                                        
                                        // Tampilkan notifikasi
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Produk telah ditambahkan ke keranjang'),
                                            duration: const Duration(seconds: 2),
                                            action: SnackBarAction(
                                              label: 'LIHAT',
                                              onPressed: () {
                                                Navigator.pushNamed(context, '/cart');
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Tambah ke Keranjang",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Spacer for Bottom Navigation
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
     
      
      // Bottom Cart Bar
      bottomNavigationBar: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.amber,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.shopping_cart, color: Colors.black, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Keranjang\n(${_cartService.itemCount} Barang)',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Rp${_cartService.totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}