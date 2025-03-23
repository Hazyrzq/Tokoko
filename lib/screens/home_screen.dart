import 'package:flutter/material.dart';
import 'food_category_screen.dart';
import 'news_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller untuk page view banner
  final PageController _pageController = PageController();
  int _currentBannerIndex = 0;
  
  // List banner images
  final List<Map<String, dynamic>> _banners = [
    {
      'image': 'assets/images/banner1.png',
      'title': 'SALE UP TO 50%',
      'icon': Icons.shopping_bag_outlined
    },
    {
      'image': 'assets/images/banner2.png',
      'title': 'SPECIAL OFFERS',
      'icon': Icons.local_offer_outlined
    },
    {
      'image': 'assets/images/banner1.png',
      'title': 'NEW ARRIVALS',
      'icon': Icons.new_releases_outlined
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar untuk responsivitas
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 360;
    final double horizontalPadding = isSmallScreen ? 12.0 : 16.0;

    // Definisi warna utama
    final primaryColor = const Color(0xFF2D7BEE);
    final secondaryColor = const Color(0xFFE3F2FD);
    final accentColor = Colors.amber;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with profile and notification - Modern design
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryColor, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: isSmallScreen ? 18 : 22,
                              backgroundColor: secondaryColor,
                              child: Icon(Icons.person, color: primaryColor, size: isSmallScreen ? 18 : 22),
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 10 : 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Halo, Guis!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isSmallScreen ? 14 : 16,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Pesan kebutuhan favorit kamu',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 12 : 13,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.notifications_none_rounded, color: primaryColor),
                            iconSize: isSmallScreen ? 22 : 24,
                            onPressed: () {
                              // Navigator.push to notification page if needed
                            },
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search Bar - Modern with shadow
              Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari produk favorit...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: primaryColor),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(Icons.tune, color: primaryColor, size: 20),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12.0 : 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: primaryColor.withOpacity(0.3), width: 1),
                      ),
                    ),
                  ),
                ),
              ),

              // Banner Carousel with Indicators
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  children: [
                    Container(
                      height: screenWidth * 0.35, // Membuat tinggi responsif
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _banners.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentBannerIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.asset(
                                _banners[index]['image'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: index % 2 == 0 
                                            ? [primaryColor, primaryColor.withOpacity(0.7)]
                                            : [accentColor, accentColor.withOpacity(0.7)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(_banners[index]['icon'], size: 40, color: Colors.white),
                                          const SizedBox(height: 8),
                                          Text(
                                            _banners[index]['title'],
                                            style: const TextStyle(
                                              color: Colors.white, 
                                              fontWeight: FontWeight.bold, 
                                              fontSize: 16
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Carousel Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _banners.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 8,
                          width: _currentBannerIndex == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentBannerIndex == index 
                                ? primaryColor 
                                : Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Shopping Category Header - Modern with accent
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                          'Shopping Category',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text('View All'),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, size: 12, color: primaryColor),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Category Boxes - Modern glass effect
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = (constraints.maxWidth - 16) / 3;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FoodCategoryScreen(),
                              ),
                            );
                          },
                          child: _buildModernCategoryItem(
                            'Foods',
                            'assets/images/foods.png',
                            Colors.blue[100]!,
                            primaryColor,
                            width: itemWidth,
                          ),
                        ),
                        _buildModernCategoryItem(
                          'Kitchen &\nIngredients',
                          'assets/images/dapur.png',
                          Colors.orange[100]!,
                          Colors.orange[800]!,
                          width: itemWidth,
                        ),
                        _buildModernCategoryItem(
                          'Drinks',
                          'assets/images/minum.png',
                          Colors.green[100]!,
                          Colors.green[800]!,
                          width: itemWidth,
                        ),
                      ],
                    );
                  }
                ),
              ),
              const SizedBox(height: 20),

              // Festival Ramadhan Section - Modern design
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                              'Festival Ramadhan',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: accentColor,
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Text('View All'),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios, size: 12, color: accentColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 210, // Slightly taller for modern design
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildModernProductItem(
                            "Kurma Khotas",
                            "27.000",
                            "assets/images/kurma khalas.png",
                            "29.000",
                            discount: 7,
                            accentColor: accentColor,
                          ),
                          const SizedBox(width: 12),
                          _buildModernProductItem(
                            "Monde",
                            "63.000",
                            "assets/images/mondee.png",
                            "65.900",
                            discount: 5,
                            accentColor: accentColor,
                          ),
                          const SizedBox(width: 12),
                          _buildModernProductItem(
                            "Alpenliebe",
                            "27.000",
                            "assets/images/alpen.png",
                            "28.000",
                            discount: 4,
                            accentColor: accentColor,
                          ),
                          const SizedBox(width: 12),
                          _buildModernProductItem(
                            "Biskuit",
                            "15.000",
                            "assets/images/tango.png",
                            "17.500",
                            discount: 14,
                            accentColor: accentColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80), // Space for navbar
            ],
          ),
        ),
      ),
      // Hapus floatingActionButton
      // Hapus bottomNavigationBar
    );
  }

  Widget _buildModernCategoryItem(
    String name,
    String imagePath,
    Color backgroundColor,
    Color iconColor, {
    required double width,
  }) {
    final bool isNameLong = name.length > 6;
    
    return Container(
      width: width,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.5),
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
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              name,
              style: TextStyle(
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
        ],
      ),
    );
  }

  Widget _buildModernProductItem(
    String name,
    String price,
    String imagePath,
    String originalPrice, {
    int? discount,
    required Color accentColor,
  }) {
    return Container(
      width: 150,
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
                height: 100,
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