import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';

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
  
  @override
  void initState() {
    super.initState();
    // Load saved address if exists
    _loadSavedAddress();
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

                  // Delivery address section - Updated to show address input if no address is saved
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
                                        'Please add a delivery address',
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
                                  deliveryAddress.isEmpty ? Icons.add : Icons.edit_outlined,
                                  color: primaryColor,
                                  size: 16,
                                ),
                              ),
                              onPressed: () {
                                // Show dialog to add/edit address
                                _showEditAddressDialog(context, primaryColor);
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
  
  // Updated method to show edit address dialog
  void _showEditAddressDialog(BuildContext context, Color primaryColor) {
    // Set the initial value of the text controller to current address
    _addressController.text = deliveryAddress;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          deliveryAddress.isEmpty ? 'Add Delivery Address' : 'Edit Delivery Address',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        content: TextField(
          controller: _addressController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter your delivery address',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black87,
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
              // Update and save the address
              final newAddress = _addressController.text;
              setState(() {
                deliveryAddress = newAddress;
              });
              // Save to SharedPreferences to persist
              _saveAddress(newAddress);
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: GoogleFonts.poppins(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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