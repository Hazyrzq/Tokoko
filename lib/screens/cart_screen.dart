import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';
import '../providers/location_provider.dart';
import '../widgets/map_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  // Start with empty address
  String deliveryAddress = '';
  final TextEditingController _addressController = TextEditingController();
  LatLng? _selectedLocation; // Add this line after existing variables

  MapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

// Animation controllers (tambahkan jika ingin animasi)
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Load saved address if exists
    _loadSavedAddress();
    // Initialize location service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      locationProvider.initializeLocationService();
    });

  }

  // Method to load saved address from SharedPreferences
  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      deliveryAddress = prefs.getString('user_address') ?? '';
    });
  }

  // Method to save address to SharedPreferences
  Future<void> _saveAddress(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_address', address);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose(); // Add this line
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF2D7BEE);
    final secondaryColor = const Color(0xFFFF8C00);

    // Buat listener untuk perubahan pada CartService
    return AnimatedBuilder(
      animation: _cartService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Shopping Cart',
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: primaryColor,
                  size: 16,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Stack(
            children: [
              // Background decorations
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                left: -100,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: secondaryColor.withOpacity(0.05),
                  ),
                ),
              ),

              // Main content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header keranjang dengan jumlah item dan tombol hapus
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Item count badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.shopping_bag_outlined, size: 16, color: primaryColor),
                              const SizedBox(width: 4),
                              Text(
                                "${_cartService.itemCount} items",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Delete button
                        TextButton.icon(
                          onPressed: _cartService.itemCount == 0
                              ? null
                              : () {
                            // Implementasi fungsi kosongkan keranjang
                            showDialog(
                              context: context,
                              builder: (context) => _buildClearCartDialog(context, primaryColor),
                            );
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            color: _cartService.itemCount == 0 ? Colors.grey[400] : Colors.red[400],
                            size: 18,
                          ),
                          label: Text(
                            'Clear Cart',
                            style: GoogleFonts.poppins(
                              color: _cartService.itemCount == 0 ? Colors.grey[400] : Colors.red[400],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Delivery address section - Updated with GPS support
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.location_on_outlined,
                                color: primaryColor,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Delivery Address',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  deliveryAddress.isEmpty
                                      ? Text(
                                    'Please select a delivery location',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                      : Text(
                                    deliveryAddress,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  deliveryAddress.isEmpty ? Icons.map : Icons.edit_location_outlined,
                                  color: primaryColor,
                                  size: 16,
                                ),
                              ),
                              onPressed: () {
                                // Show dialog to add/edit address with GPS option
                                _showMapDialog(context, primaryColor);
                              },
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Daftar item keranjang
                  Expanded(
                    child: _cartService.itemCount == 0
                        ? _buildEmptyCart(primaryColor)
                        : _buildCartItems(primaryColor),
                  ),

                  // Total and checkout button
                  _buildCheckoutSection(primaryColor),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Updated method to show edit address dialog with GPS integration
  void _showMapDialog(BuildContext context, Color primaryColor) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.map_outlined, color: primaryColor, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Select Delivery Location', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                              Text('Tap on the map to select your delivery address', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: Colors.grey[600])),
                      ],
                    ),
                  ),

                  // Search Box - ADD THIS SECTION
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Type address (e.g., Jakarta, Bandung, Surabaya)',
                                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[500]),
                                  prefixIcon: Icon(Icons.search, color: primaryColor, size: 20),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                    icon: Icon(Icons.clear, color: Colors.grey[400], size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                  )
                                      : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: primaryColor, width: 2),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                style: GoogleFonts.poppins(fontSize: 14),
                                onChanged: (value) => setState(() {}),
                                onSubmitted: (value) => _searchLocation(value, locationProvider),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              height: 48,
                              width: 48,
                              child: ElevatedButton(
                                onPressed: _isSearching || _searchController.text.trim().isEmpty
                                    ? null
                                    : () => _searchLocation(_searchController.text, locationProvider),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: EdgeInsets.zero,
                                ),
                                child: _isSearching
                                    ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                                    : Icon(Icons.search, size: 20),
                              ),
                            ),
                          ],
                        ),

                        // Quick location suggestions
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildQuickLocationChip('Jakarta', primaryColor, locationProvider),
                              _buildQuickLocationChip('Bandung', primaryColor, locationProvider),
                              _buildQuickLocationChip('Surabaya', primaryColor, locationProvider),
                              _buildQuickLocationChip('Yogyakarta', primaryColor, locationProvider),
                              _buildQuickLocationChip('Medan', primaryColor, locationProvider),
                              _buildQuickLocationChip('Makassar', primaryColor, locationProvider),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Map
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: MapWidget(
                        height: double.infinity,
                        showCurrentLocation: true,
                        initialLocation: _selectedLocation,
                        onLocationSelected: (latLng) async {
                          _selectedLocation = latLng;
                          String? address = await locationProvider.getAddressFromLatLng(latLng);

                          if (address != null) {
                            setState(() { deliveryAddress = address; });
                            _saveAddress(address);
                          } else {
                            String coordAddress = '📍 ${latLng.latitude.toStringAsFixed(6)}, ${latLng.longitude.toStringAsFixed(6)}';
                            setState(() { deliveryAddress = coordAddress; });
                            _saveAddress(coordAddress);
                          }
                        },
                        onMapReady: (MapController controller) {
                          _mapController = controller;
                        },
                      ),
                    ),
                  ),

                  // Bottom buttons
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // GPS Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: locationProvider.isLoading ? null : () async {
                              bool success = await locationProvider.getCurrentLocation();
                              if (success && locationProvider.currentLatLng != null) {
                                _selectedLocation = locationProvider.currentLatLng;
                                if (locationProvider.currentAddress != null) {
                                  setState(() { deliveryAddress = locationProvider.currentAddress!; });
                                  _saveAddress(locationProvider.currentAddress!);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Current location selected'), backgroundColor: Colors.green[600]),
                                  );
                                }
                              }
                            },
                            icon: locationProvider.isLoading
                                ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                                : Icon(Icons.my_location, size: 18),
                            label: Text(locationProvider.isLoading ? 'Getting Location...' : '📍 Use My Current Location'),
                            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)),
                          ),
                        ),

                        if (_selectedLocation != null || deliveryAddress.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location confirmed'), backgroundColor: Colors.green[600]));
                              },
                              icon: const Icon(Icons.check_circle_outline, size: 18),
                              label: Text('Confirm Location'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600], foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickLocationChip(String city, Color primaryColor, LocationProvider locationProvider) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _searchController.text = city;
          });
          _searchLocation(city, locationProvider);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryColor.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_city, size: 14, color: primaryColor),
              const SizedBox(width: 4),
              Text(
                city,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart(Color primaryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your Cart is Empty',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Looks like you haven\'t added anything\nto your cart yet.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
              label: Text(
                'Continue Shopping',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchLocation(String address, LocationProvider locationProvider) async {
    if (address.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      LatLng? coordinates = await locationProvider.getLatLngFromAddress(address);

      if (coordinates != null) {
        // Set location dan trigger map update
        setState(() {
          _selectedLocation = coordinates;
        });

        // PENTING: Trigger map controller untuk pindah ke lokasi baru
        _mapController?.move(coordinates, 15.0);

        // Get detailed address from coordinates
        String? detailedAddress = await locationProvider.getAddressFromLatLng(coordinates);

        setState(() {
          deliveryAddress = detailedAddress ?? address;
        });
        _saveAddress(deliveryAddress);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Location found: ${detailedAddress ?? address}',
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Location not found. Please try a different address.',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error searching location: $e'),
          backgroundColor: Colors.red[600],
        ),
      );
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  // UPDATED: Cart items with enhanced price display showing multiplication
  Widget _buildCartItems(Color primaryColor) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _cartService.items.length,
      itemBuilder: (context, index) {
        final item = _cartService.items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildProductImage(item),
                  ),
                ),
                const SizedBox(width: 16),

                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        item.subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${item.price}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quantity controls with modern design
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          _buildModernCircularButton(
                            icon: Icons.remove,
                            onPressed: () {
                              _cartService.updateQuantity(
                                item.id,
                                item.quantity - 1,
                              );
                            },
                            primaryColor: primaryColor,
                          ),
                          SizedBox(
                            width: 32,
                            child: Text(
                              item.quantity.toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _buildModernCircularButton(
                            icon: Icons.add,
                            onPressed: () {
                              _cartService.updateQuantity(
                                item.id,
                                item.quantity + 1,
                              );
                            },
                            primaryColor: primaryColor,
                          ),
                        ],
                      ),
                    ),

                    // Enhanced subtotal with calculation shown
                    if (item.quantity > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Price calculation (quantity x price)
                            Row(
                              children: [
                                Text(
                                  '${item.quantity} × Rp ${item.price}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            // Total price
                            Text(
                              'Rp ${item.price * item.quantity}',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                    // Just show price for single quantity
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Rp ${item.price * item.quantity}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // UPDATED: Enhanced checkout section with a more detailed summary
  Widget _buildCheckoutSection(Color primaryColor) {
    // Check if address is empty or cart is empty to disable checkout button
    bool isCheckoutDisabled = _cartService.itemCount == 0 || deliveryAddress.isEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Pricing summary with enhanced details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal (${_cartService.itemCount} ${_cartService.itemCount > 1 ? 'items' : 'item'})',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'Rp ${_cartService.totalAmount}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping Fee',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'FREE',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[600],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Rp ${_cartService.totalAmount}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Address warning if empty
          if (deliveryAddress.isEmpty && _cartService.itemCount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Please add a delivery address to proceed',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.red[400],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          // Checkout button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isCheckoutDisabled
                      ? [Colors.grey[400]!, Colors.grey[300]!]
                      : [primaryColor, primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: isCheckoutDisabled
                    ? []
                    : [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: isCheckoutDisabled
                    ? null
                    : () {
                  // Navigate to checkout with saved address
                  // Pass the address to the checkout screen
                  Navigator.pushNamed(
                      context,
                      '/checkout',
                      arguments: {'address': deliveryAddress}
                  );
                },
                icon: const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white),
                label: Text(
                  'Proceed to Checkout',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClearCartDialog(BuildContext context, Color primaryColor) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Clear Cart',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
      content: Text(
        'Are you sure you want to clear all items from your cart?',
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            _cartService.clear();
            Navigator.pop(context);
          },
          child: Text(
            'Clear',
            style: GoogleFonts.poppins(
              color: Colors.red[500],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Modern circular button for quantity controls
  Widget _buildModernCircularButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color primaryColor,
  }) {
    return SizedBox(
      width: 28,
      height: 28,
      child: IconButton(
        icon: Icon(icon, size: 16),
        color: primaryColor,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: onPressed,
      ),
    );
  }

  // Widget untuk memuat gambar dengan fallback
  Widget _buildProductImage(CartItem item) {
    try {
      return Image.asset(
        item.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(
              item.name.substring(0, 1).toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          );
        },
      );
    } catch (e) {
      // Tampilkan inisial jika terjadi error
      return Center(
        child: Text(
          item.name.substring(0, 1).toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      );
    }
  }
}