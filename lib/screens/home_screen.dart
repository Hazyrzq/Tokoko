import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'food_category_screen.dart';
import 'news_screen.dart';
import 'all_categories_screen.dart';
import 'ramadhan_products_screen.dart';
import '../providers/profile_provider.dart';
import 'kitchen_ingredients_category_screen.dart';
import 'drinks_category_screen.dart';
import '../services/cart_service.dart';
import '../models/product.dart';
import '../widgets/cart_badge.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller untuk page view banner
  final PageController _pageController = PageController();
  int _currentBannerIndex = 0;
  final CartService _cartService = CartService();
  
  // Controller untuk text field pencarian
  final TextEditingController _searchController = TextEditingController();
  
  // Flag untuk menampilkan hasil pencarian
  bool _isSearching = false;
  
  // Daftar semua produk (contoh data)
  final List<Map<String, dynamic>> _allProducts = [
    {
      'name': 'Kurma Khotas',
      'price': '27.000',
      'originalPrice': '29.000',
      'image': 'assets/images/kurma khalas.png',
      'discount': 7,
      'category': 'Ramadhan',
    },
    {
      'name': 'Monde',
      'price': '63.000',
      'originalPrice': '65.900',
      'image': 'assets/images/mondee.png',
      'discount': 5,
      'category': 'Ramadhan',
    },
    {
      'name': 'Alpenliebe',
      'price': '27.000',
      'originalPrice': '28.000',
      'image': 'assets/images/alpen.png',
      'discount': 4,
      'category': 'Ramadhan',
    },
    {
      'name': 'Biskuit',
      'price': '15.000',
      'originalPrice': '17.500',
      'image': 'assets/images/tango.png',
      'discount': 14,
      'category': 'Ramadhan',
    },
    {
      'name': 'Indomie Goreng',
      'price': '3.500',
      'originalPrice': '4.000',
      'image': 'assets/images/indomie.png',
      'discount': 12,
      'category': 'Foods',
    },
    {
      'name': 'Fitbar Fruit',
      'price': '5.000',
      'originalPrice': '6.000',
      'image': 'assets/images/fitbar.png',
      'discount': 16,
      'category': 'Foods',
    },
    {
      'name': 'Chiki Balls',
      'price': '7.000',
      'originalPrice': '8.500',
      'image': 'assets/images/chiki.png',
      'discount': 18,
      'category': 'Foods',
    },
    {
      'name': 'Coca Cola',
      'price': '6.000',
      'originalPrice': '7.000',
      'image': 'assets/images/minum.png',
      'discount': 15,
      'category': 'Drinks',
    },
  ];
  
  // List hasil pencarian
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  
  // Method untuk mencari produk
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }
    
    final results = _allProducts.where((product) {
      final productName = product['name'].toString().toLowerCase();
      final productCategory = product['category'].toString().toLowerCase();
      return productName.contains(query) || productCategory.contains(query);
    }).toList();
    
    setState(() {
      _isSearching = true;
      _searchResults = results;
    });
  }
  
  // Method untuk mengosongkan pencarian
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchResults = [];
    });
    // Tutup keyboard
    FocusScope.of(context).unfocus();
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

    // Access the profile provider
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
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
              child: Consumer2<ProfileProvider, AuthProvider>(
                builder: (context, profileProvider, authProvider, child) {
                  // Use Firebase user data if available, fallback to profile provider
                  String displayName = authProvider.user?.nama ?? profileProvider.nama;
                  String displayPhotoUrl = authProvider.user?.fotoProfilUrl ?? profileProvider.fotoProfilPath;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            // Profile Image from AuthProvider/ProfileProvider
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryColor, width: 2),
                              ),
                              child: _buildProfileImageHeader(
                                displayPhotoUrl,
                                displayName,
                                isSmallScreen ? 18 : 22,
                                primaryColor,
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 10 : 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Halo, $displayName!',
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

                      // Row untuk notification dan cart
                      Row(
                        children: [
                          // Notification icon with counter
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.notifications_none_rounded,
                                    color: primaryColor,
                                  ),
                                  iconSize: isSmallScreen ? 22 : 24,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const NewsScreen(
                                          showBackButton: true,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${NewsScreen.notificationCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            
            // 1
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
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari produk favorit...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.search, color: primaryColor),
                    suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[400], size: 20),
                        onPressed: _clearSearch,
                      )
                    : null,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 12.0 : 15.0,
                    ),
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
                      borderSide: BorderSide(
                        color: primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content berdasarkan status pencarian
            Expanded(
              child: _isSearching
                ? _buildSearchResults(accentColor, horizontalPadding)
                : _buildNormalContent(
                    screenWidth,
                    horizontalPadding,
                    primaryColor,
                    secondaryColor,
                    accentColor
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // Method untuk membangun gambar profil di header - Updated untuk Firebase
  Widget _buildProfileImageHeader(
      String? photoUrl,
      String name,
      double radius,
      Color primaryColor,
      ) {
    try {
      // If we have a Firebase Storage URL
      if (photoUrl != null && photoUrl.startsWith('http')) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0xFFE3F2FD),
          backgroundImage: NetworkImage(photoUrl),
          onBackgroundImageError: (_, __) {
            // Error handler akan fallback ke widget dibawah
          },
          child: null,
        );
      }
      // If it's an asset image
      else if (photoUrl != null && photoUrl.startsWith('assets/')) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0xFFE3F2FD),
          backgroundImage: AssetImage(photoUrl),
          onBackgroundImageError: (_, __) {
            // Error handler akan fallback ke widget dibawah
          },
        );
      }
      // If it's a local file
      else if (photoUrl != null && photoUrl.isNotEmpty && !photoUrl.startsWith('assets/')) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0xFFE3F2FD),
          backgroundImage: FileImage(File(photoUrl)),
          onBackgroundImageError: (_, __) {
            // Error handler akan fallback ke widget dibawah
          },
        );
      }
      // Default avatar with initials or icon
      else {
        return _buildDefaultAvatarHeader(name, radius, primaryColor);
      }
    } catch (e) {
      // If any error occurs, show default avatar
      return _buildDefaultAvatarHeader(name, radius, primaryColor);
    }
  }

  // Method untuk avatar default di header
  Widget _buildDefaultAvatarHeader(String name, double radius, Color primaryColor) {
    if (name.isEmpty || name == 'Guest User') {
      return CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFFE3F2FD),
        child: Icon(Icons.person, color: primaryColor, size: radius),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: primaryColor,
      child: Text(
        name[0].toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }

  // Membangun tampilan hasil pencarian
  Widget _buildSearchResults(Color accentColor, double horizontalPadding) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Produk tidak ditemukan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba kata kunci lain',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                Text(
                  'Hasil Pencarian (${_searchResults.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final product = _searchResults[index];
                return _buildProductItem(
                  product['name'],
                  product['price'],
                  product['image'],
                  product['originalPrice'],
                  discount: product['discount'],
                  accentColor: accentColor,
                  category: product['category'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // Membangun produk untuk hasil pencarian
  Widget _buildProductItem(
    String name,
    String price,
    String imagePath,
    String originalPrice, {
    int? discount,
    required Color accentColor,
    required String category,
  }) {
    // Convert price dari string "27.000" ke double 27000.0
    final double priceValue = double.parse(price.replaceAll('.', ''));
    // Generate ID product yang unik berdasarkan nama (cukup untuk demo)
    final String productId = name.toLowerCase().replaceAll(' ', '_');
    
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
                        child: Icon(
                          Icons.image_not_supported,
                          size: 30,
                          color: Colors.grey[400],
                        ),
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
              // Category badge
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
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
              InkWell(
                onTap: () {
                  // Buat objek Product
                  final product = Product(
                    id: productId,
                    name: name,
                    price: priceValue,
                    imageUrl: imagePath,
                    subtitle: category,
                    rating: 5.0, // Default rating
                  );
                  
                  // Tambahkan ke keranjang
                  _cartService.addProduct(product);
                  
                  // Refresh UI
                  setState(() {});
                  
                  // Tampilkan snackbar konfirmasi
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name telah ditambahkan ke keranjang'),
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2
  
  // Mendapatkan warna berdasarkan kategori
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'ramadhan':
        return Colors.amber;
      case 'foods':
        return Colors.blue;
      case 'drinks':
        return Colors.green[700]!;
      default:
        return Colors.purple;
    }
  }
  
  // Membangun konten normal (tanpa pencarian)
  Widget _buildNormalContent(
    double screenWidth,
    double horizontalPadding,
    Color primaryColor,
    Color secondaryColor,
    Color accentColor,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
                        margin: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
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
                                    colors:
                                        index % 2 == 0
                                            ? [
                                              primaryColor,
                                              primaryColor.withOpacity(0.7),
                                            ]
                                            : [
                                              accentColor,
                                              accentColor.withOpacity(0.7),
                                            ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _banners[index]['icon'],
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _banners[index]['title'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
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
                        color:
                            _currentBannerIndex == index
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
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 5,
            ),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllCategoriesScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text('Lihat Semua'),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: primaryColor,
                      ),
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
                            builder:
                                (context) => const FoodCategoryScreen(),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const KitchenIngredientsCategoryScreen(),
                          ),
                        );
                      },
                      child: _buildModernCategoryItem(
                        'Kitchen &\nIngredients',
                        'assets/images/dapur.png',
                        Colors.orange[100]!,
                        Colors.orange[800]!,
                        width: itemWidth,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const DrinksCategoryScreen(),
                          ),
                        );
                      },
                      child: _buildModernCategoryItem(
                      'Drinks',
                      'assets/images/minum.png',
                      Colors.green[100]!,
                      Colors.green[800]!,
                      width: itemWidth,
                    ),
                  )
                  ],
                );
              },
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const RamadhanProductsScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: accentColor,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text('Lihat Semua'),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: accentColor,
                          ),
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
    );
  }
  
  // List banner images
  final List<Map<String, dynamic>> _banners = [
    {
      'image': 'assets/images/banner1.png',
      'title': 'SALE UP TO 50%',
      'icon': Icons.shopping_bag_outlined,
    },
    {
      'image': 'assets/images/banner2.png',
      'title': 'SPECIAL OFFERS',
      'icon': Icons.local_offer_outlined,
    },
    {
      'image': 'assets/images/banner1.png',
      'title': 'NEW ARRIVALS',
      'icon': Icons.new_releases_outlined,
    },
  ];

  // Method untuk membangun gambar profil
  Widget _buildProfileImage(
    ProfileProvider profileProvider,
    double radius,
    Color primaryColor,
  ) {
    try {
      if (profileProvider.fotoProfilPath.isEmpty) {
        // Jika tidak ada foto profil, tampilkan avatar default
        return CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0xFFE3F2FD),
          child: Icon(Icons.person, color: primaryColor, size: radius),
        );
      } else if (profileProvider.fotoProfilPath.startsWith('assets/')) {
        // Jika foto dari asset
        return CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0xFFE3F2FD),
          backgroundImage: AssetImage(profileProvider.fotoProfilPath),
          onBackgroundImageError: (_, __) {
            // Error handler tidak mengembalikan nilai, hanya untuk menangani error
          },
        );
      } else {
        // Jika dari file lokal
        return CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0xFFE3F2FD),
          backgroundImage: FileImage(File(profileProvider.fotoProfilPath)),
          onBackgroundImageError: (_, __) {
            // Error handler tidak mengembalikan nilai, hanya untuk menangani error
          },
        );
      }
    } catch (e) {
      // Jika terjadi error, tampilkan inisial
      return CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFFE3F2FD),
        child: Text(
          profileProvider.nama.isNotEmpty
              ? profileProvider.nama[0].toUpperCase()
              : "?",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: radius,
          ),
        ),
      );
    }
  }

  // Method untuk membangun item kategori
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

  // Method untuk membangun item produk dengan fungsi tambah ke keranjang
  Widget _buildModernProductItem(
    String name,
    String price,
    String imagePath,
    String originalPrice, {
    int? discount,
    required Color accentColor,
  }) {
    // Convert price dari string "27.000" ke double 27000.0
    final double priceValue = double.parse(price.replaceAll('.', ''));
    // Generate ID product yang unik berdasarkan nama (cukup untuk demo)
    final String productId = name.toLowerCase().replaceAll(' ', '_');
    
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
                        child: Icon(
                          Icons.image_not_supported,
                          size: 30,
                          color: Colors.grey[400],
                        ),
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
              InkWell(
                onTap: () {
                  // Buat objek Product
                  final product = Product(
                    id: productId,
                    name: name,
                    price: priceValue,
                    imageUrl: imagePath,
                    subtitle: "Festival Ramadhan",
                    rating: 5.0, // Default rating
                  );
                  
                  // Tambahkan ke keranjang
                  _cartService.addProduct(product);
                  
                  // Refresh UI
                  setState(() {});
                  
                  // Tampilkan snackbar konfirmasi
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name telah ditambahkan ke keranjang'),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}