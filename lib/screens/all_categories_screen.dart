import 'package:flutter/material.dart';
import 'food_category_screen.dart';
import 'cart_screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar untuk responsivitas
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 360;
    final double horizontalPadding = isSmallScreen ? 12.0 : 16.0;

    // Definisi warna utama
    final primaryColor = const Color(0xFF2D7BEE);
    final secondaryColor = const Color(0xFFE3F2FD);
    
    return Scaffold(
      backgroundColor: Colors.white, // Background putih untuk seluruh layar
      appBar: AppBar(
        title: Text(
          'Semua Kategori',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20, color: primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian kategori dengan latar belakang abu-abu sangat muda
              Container(
                color: Colors.grey[50], // Warna abu-abu sangat muda
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header kategori dengan bar biru
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 16.0),
                      child: Row(
                        children: [
                          Container(
                            height: 18,
                            width: 4,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Pilih Kategori Belanja',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Grid kategori
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                      children: [
                        // Kategori Foods
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FoodCategoryScreen(),
                              ),
                            );
                          },
                          child: _buildCategoryItem(
                            'Foods',
                            'assets/images/foods.png',
                            Colors.blue[100]!,
                            primaryColor,
                          ),
                        ),
                        
                        // Kategori Kitchen & Ingredients
                        _buildCategoryItem(
                          'Kitchen & Ingredients',
                          'assets/images/dapur.png',
                          Colors.orange[100]!,
                          Colors.orange[800]!,
                        ),
                        
                        // Kategori Drinks
                        _buildCategoryItem(
                          'Drinks',
                          'assets/images/minum.png',
                          Colors.green[100]!,
                          Colors.green[800]!,
                        ),
                        
                        // Kategori tambahan dengan warna yang berbeda-beda
                        _buildCategoryItem(
                          'Snacks',
                          'assets/images/foods.png',
                          Colors.pink[100]!,
                          Colors.pink[800]!,
                        ),
                        
                        _buildCategoryItem(
                          'Frozen Food',
                          'assets/images/foods.png',
                          Colors.purple[100]!,
                          Colors.purple[800]!,
                        ),
                        
                        _buildCategoryItem(
                          'Fresh Fruits',
                          'assets/images/foods.png',
                          Colors.amber[100]!,
                          Colors.amber[800]!,
                        ),
                        
                        _buildCategoryItem(
                          'Vegetables',
                          'assets/images/foods.png',
                          Colors.lightGreen[100]!,
                          Colors.lightGreen[800]!,
                        ),
                        
                        _buildCategoryItem(
                          'Personal Care',
                          'assets/images/foods.png',
                          Colors.teal[100]!,
                          Colors.teal[800]!,
                        ),
                        
                        _buildCategoryItem(
                          'Home Care',
                          'assets/images/foods.png',
                          Colors.blue[100]!,
                          Colors.blue[800]!,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Promo Spesial Banner
              Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Container(
                  width: double.infinity,
                  height: 90,
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Teks promo
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Promo Spesial',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Dapatkan diskon hingga 50% untuk produk pilihan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        
                        // Tombol Lihat
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Lihat',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    String name,
    String imagePath,
    Color backgroundColor,
    Color iconColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 12, top: 10),
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              imagePath,
              height: 40,
              width: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.category, color: iconColor, size: 30);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.black87,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}