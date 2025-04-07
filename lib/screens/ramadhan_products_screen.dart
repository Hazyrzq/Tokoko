import 'package:flutter/material.dart';

class RamadhanProductsScreen extends StatelessWidget {
  const RamadhanProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar untuk responsivitas
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 360;
    final double horizontalPadding = isSmallScreen ? 12.0 : 16.0;

    // Definisi warna utama
    final primaryColor = const Color(0xFF2D7BEE);
    final accentColor = Colors.amber;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true, // Centered title
        title: Text(
          'Festival Ramadhan', 
          style: TextStyle(
            color: Colors.black87, // Changed to black
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor), // Ensure back button is blue
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtitle dengan aksen
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Container(
                        height: 18,
                        width: 4,
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Produk Spesial Ramadhan',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Banner Ramadhan
                Container(
                  width: double.infinity,
                  height: 150,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [accentColor, accentColor.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            bottom: -20,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            left: -30,
                            top: -30,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Diskon Special Ramadhan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Promo spesial untuk persiapan bulan suci Ramadhan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Grid produk Ramadhan
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 8, // Jumlah produk
                  itemBuilder: (context, index) {
                    // Data produk untuk contoh - menggunakan cara yang lebih sederhana
                    // untuk mengatasi error casting object ke string
                    
                    // Menggunakan data hardcoded sementara
                    String name;
                    String price;
                    String image;
                    String originalPrice;
                    int discount;
                    
                    // Mendefinisikan data berdasarkan index
                    switch (index % 8) {
                      case 0:
                        name = "Kurma Khotas";
                        price = "27.000";
                        image = "assets/images/kurma khalas.png";
                        originalPrice = "29.000";
                        discount = 7;
                        break;
                      case 1:
                        name = "Monde";
                        price = "63.000";
                        image = "assets/images/mondee.png";
                        originalPrice = "65.900";
                        discount = 5;
                        break;
                      case 2:
                        name = "Alpenliebe";
                        price = "27.000";
                        image = "assets/images/alpen.png";
                        originalPrice = "28.000";
                        discount = 4;
                        break;
                      case 3:
                        name = "Biskuit";
                        price = "15.000";
                        image = "assets/images/tango.png";
                        originalPrice = "17.500";
                        discount = 14;
                        break;
                      case 4:
                        name = "Sirup ABC";
                        price = "18.500";
                        image = "assets/images/foods.png";
                        originalPrice = "22.000";
                        discount = 15;
                        break;
                      case 5:
                        name = "Kue Kering";
                        price = "45.000";
                        image = "assets/images/foods.png";
                        originalPrice = "50.000";
                        discount = 10;
                        break;
                      case 6:
                        name = "Aneka Oleh-oleh";
                        price = "35.000";
                        image = "assets/images/foods.png";
                        originalPrice = "38.000";
                        discount = 8;
                        break;
                      default: // case 7
                        name = "Makanan Tradisional";
                        price = "25.000";
                        image = "assets/images/foods.png";
                        originalPrice = "28.000";
                        discount = 10;
                        break;
                    }
                    
                    return _buildProductItem(
                      name,
                      price,
                      image,
                      originalPrice,
                      discount: discount,
                      accentColor: accentColor,
                    );
                  },
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(
    String name,
    String price,
    String imagePath,
    String originalPrice, {
    int? discount,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.image_not_supported, size: 30, color: Colors.grey[400]),
                      );
                    },
                  ),
                ),
              ),
              if (discount != null)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "-$discount%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Product Title
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Price
          Text(
            "Rp $price",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
              fontSize: 15,
            ),
          ),

          // Original Price and Add button
          Row(
            children: [
              Text(
                "Rp $originalPrice",
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.4),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}