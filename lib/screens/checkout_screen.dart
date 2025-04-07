import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/cart_service.dart';
import '../services/transaction_service.dart';
import '../models/cart_item.dart';
import 'package:transparent_image/transparent_image.dart';
import '../screens/transaction_screen.dart'; // Adjust the import path as needed

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartService _cartService = CartService();
  final TransactionService _transactionService = TransactionService();
  String _selectedShippingOption = 'Standard';
  String _selectedPaymentMethod = 'Transfer Bank'; // Default payment method
  String _selectedBank = ''; // Menyimpan bank yang dipilih
  bool _isProcessingPayment = false;

  // This will store the delivery address passed from CartScreen
  String _deliveryAddress = '';

  // Contact information
  String _contactPhone = '+6281000000';
  String _contactEmail = 'emailsample@example.com';

  // Text controllers for editing
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Calculate total amount including shipping cost
  double get totalAmount {
    double cartTotal = _cartService.totalAmount.toDouble();
    double shippingCost = _selectedShippingOption == 'Express' ? 12000 : 0;
    return cartTotal + shippingCost;
  }

  @override
  void initState() {
    super.initState();
    _phoneController.text = _contactPhone;
    _emailController.text = _contactEmail;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the arguments passed from the CartScreen
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments.containsKey('address')) {
      setState(() {
        _deliveryAddress = arguments['address'] as String;
        _addressController.text = arguments['address'] as String;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF2D7BEE);
    final secondaryColor = const Color(0xFFFF8C00);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
        title: Text(
          'Checkout',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
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
          AnimatedBuilder(
            animation: _cartService,
            builder: (context, child) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order Summary Card
                            _buildSectionTitle("Order Summary", primaryColor),
                            const SizedBox(height: 12),

                            // Items Count & Add Voucher
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.shopping_bag_outlined,
                                            size: 16,
                                            color: primaryColor,
                                          ),
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
                                  ],
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    // Add voucher functionality
                                  },
                                  icon: Icon(
                                    Icons.local_offer_outlined,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                  label: Text(
                                    'Add Voucher',
                                    style: GoogleFonts.poppins(
                                      color: primaryColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: primaryColor,
                                    side: BorderSide(color: primaryColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Items List
                            Container(
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
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _cartService.items.length,
                                separatorBuilder:
                                    (context, index) => Divider(
                                      height: 1,
                                      color: Colors.grey[200],
                                    ),
                                itemBuilder: (context, index) {
                                  final item = _cartService.items[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        // Product image
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: _buildProductImage(item),
                                        ),
                                        const SizedBox(width: 12),
                                        // Product details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                "Rp${item.price}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Quantity
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            '${item.quantity}x',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Price
                                        Text(
                                          'Rp${item.price * item.quantity}',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Shipping Address - Modified to remove the edit functionality
                            _buildSectionTitle(
                              "Shipping Address",
                              primaryColor,
                            ),
                            const SizedBox(height: 12),
                            // Modified to use a non-editable version for address
                            _buildReadOnlyInfoCard(
                              icon: Icons.location_on_outlined,
                              iconColor: primaryColor,
                              title: "Delivery Address",
                              description:
                                  _deliveryAddress.isNotEmpty
                                      ? _deliveryAddress
                                      : "Please add a delivery address on the previous page",
                            ),

                            const SizedBox(height: 24),

                            // Contact Information
                            _buildSectionTitle(
                              "Contact Information",
                              primaryColor,
                            ),
                            const SizedBox(height: 12),
                            _buildInfoCard(
                              icon: Icons.phone_outlined,
                              iconColor: secondaryColor,
                              title: "Contact",
                              description: "$_contactPhone \n$_contactEmail",
                              onTap: () {
                                // Show dialog to edit contact information
                                _showEditContactDialog(context, secondaryColor);
                              },
                            ),

                            const SizedBox(height: 24),

                            // Shipping Options
                            _buildSectionTitle(
                              "Shipping Options",
                              primaryColor,
                            ),
                            const SizedBox(height: 12),
                            Container(
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
                              child: Column(
                                children: [
                                  // Standard Shipping
                                  _buildShippingOption(
                                    label: 'Standard',
                                    description: '1-3 days',
                                    price: 'FREE',
                                    isSelected:
                                        _selectedShippingOption == 'Standard',
                                    primaryColor: primaryColor,
                                    onTap: () {
                                      setState(() {
                                        _selectedShippingOption = 'Standard';
                                      });
                                    },
                                  ),
                                  Divider(height: 1, color: Colors.grey[200]),
                                  // Express Shipping
                                  _buildShippingOption(
                                    label: 'Express',
                                    description: 'same day',
                                    price: 'Rp12.000',
                                    isSelected:
                                        _selectedShippingOption == 'Express',
                                    primaryColor: primaryColor,
                                    onTap: () {
                                      setState(() {
                                        _selectedShippingOption = 'Express';
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Delivery Date
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Delivered on or before Thursday, 23 April 2025',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Payment Method (Diubah)
                            _buildSectionTitle("Payment Method", primaryColor),
                            const SizedBox(height: 12),
                            Container(
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
                              child: Column(
                                children: [
                                  // Transfer Bank option
                                  _buildPaymentOption(
                                    label: 'Transfer Bank',
                                    description:
                                        _selectedBank.isNotEmpty
                                            ? _selectedBank
                                            : 'Pilih bank',
                                    icon: Icons.account_balance_outlined,
                                    isSelected:
                                        _selectedPaymentMethod ==
                                        'Transfer Bank',
                                    primaryColor: primaryColor,
                                    onTap: () {
                                      setState(() {
                                        _selectedPaymentMethod =
                                            'Transfer Bank';
                                      });
                                      _showBankSelectionDialog(
                                        context,
                                        primaryColor,
                                      );
                                    },
                                  ),
                                  Divider(height: 1, color: Colors.grey[200]),
                                  // COD option
                                  _buildPaymentOption(
                                    label: 'Cash on Delivery (COD)',
                                    description: 'Bayar saat barang tiba',
                                    icon: Icons.payments_outlined,
                                    isSelected: _selectedPaymentMethod == 'COD',
                                    primaryColor: primaryColor,
                                    onTap: () {
                                      setState(() {
                                        _selectedPaymentMethod = 'COD';
                                        _selectedBank =
                                            ''; // Reset selected bank
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 80,
                            ), // Extra space for bottom bar
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Payment button bar at bottom
                  Container(
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
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Total Payment',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'Rp${totalAmount.toInt()}',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                primaryColor.withOpacity(0.8),
                              ],
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
                          child: ElevatedButton(
                            onPressed:
                                _isProcessingPayment ||
                                        _deliveryAddress.isEmpty ||
                                        _contactPhone.isEmpty ||
                                        _contactEmail.isEmpty ||
                                        (_selectedPaymentMethod ==
                                                'Transfer Bank' &&
                                            _selectedBank.isEmpty)
                                    ? null
                                    : () {
                                      setState(() {
                                        _isProcessingPayment = true;
                                      });

                                      // Simulate payment processing
                                      Future.delayed(
                                        const Duration(seconds: 2),
                                        () {
                                          setState(() {
                                            _isProcessingPayment = false;
                                          });

                                          // Add transaction to transaction service
                                          _transactionService.addTransaction(
                                            List.from(_cartService.items),
                                            totalAmount,
                                          );

                                          // Show success dialog
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder:
                                                (context) =>
                                                    _buildSuccessDialog(
                                                      context,
                                                      primaryColor,
                                                    ),
                                          );
                                        },
                                      );
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              disabledBackgroundColor: Colors.grey.withOpacity(
                                0.1,
                              ),
                              minimumSize: const Size(160, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child:
                                  _isProcessingPayment
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Pay Now',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Method untuk menampilkan dialog pilihan bank
  void _showBankSelectionDialog(BuildContext context, Color primaryColor) {
    // Daftar bank yang tersedia
    final banks = [
      {'name': 'Bank BCA', 'account': '1234567890', 'holder': 'PT TokoKu'},
      {'name': 'Bank Mandiri', 'account': '0987654321', 'holder': 'PT TokoKu'},
      {'name': 'Bank BNI', 'account': '1122334455', 'holder': 'PT TokoKu'},
      {'name': 'Bank BRI', 'account': '5544332211', 'holder': 'PT TokoKu'},
    ];

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Bank',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300, // Fixed height untuk scrollable list
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: banks.length,
                      separatorBuilder:
                          (context, index) =>
                              Divider(height: 1, color: Colors.grey[200]),
                      itemBuilder: (context, index) {
                        final bank = banks[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedBank = bank['name']!;
                            });
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.account_balance,
                                    color: primaryColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bank['name']!,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${bank['account']} (${bank['holder']})',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_selectedBank == bank['name'])
                                  Icon(
                                    Icons.check_circle,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Tutup',
                        style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
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

  // Widget untuk opsi pembayaran (Transfer Bank atau COD)
  Widget _buildPaymentOption({
    required String label,
    required String description,
    required IconData icon,
    required bool isSelected,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child:
                  isSelected
                      ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                          ),
                        ),
                      )
                      : const SizedBox(),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (label == 'Transfer Bank')
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  // Method to show edit contact dialog
  void _showEditContactDialog(BuildContext context, Color secondaryColor) {
    // Set initial values
    _phoneController.text = _contactPhone;
    _emailController.text = _contactEmail;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Edit Contact Information',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: secondaryColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: secondaryColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
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
                  // Update contact information
                  setState(() {
                    _contactPhone = _phoneController.text;
                    _contactEmail = _emailController.text;
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'Save',
                  style: GoogleFonts.poppins(
                    color: secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildSuccessDialog(BuildContext context, Color primaryColor) {
    String paymentMethod = _selectedPaymentMethod;
    String additionalInfo = '';

    if (_selectedPaymentMethod == 'Transfer Bank' && _selectedBank.isNotEmpty) {
      additionalInfo = 'via $_selectedBank';
    } else if (_selectedPaymentMethod == 'COD') {
      additionalInfo = 'Bayar saat barang tiba';
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 50,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Pesanan Berhasil!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Terima kasih atas pesanan Anda',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Metode Pembayaran: $paymentMethod\n$additionalInfo',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: Colors.grey[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedPaymentMethod == 'Transfer Bank'
                          ? 'Mohon segera lakukan pembayaran dalam 24 jam'
                          : 'Siapkan uang pas saat barang datang',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Clear cart after successful checkout
                _cartService.clear();

                // Navigate back to home
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Kembali ke Beranda',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // Clear cart before navigating to transaction screen
                _cartService.clear();

                // Navigate to order history with back button enabled
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder:
                        (context) => TransactionScreen(showBackButton: true),
                  ),
                );
              },
              child: Text(
                'Lihat Pesanan Saya',
                style: GoogleFonts.poppins(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk judul section
  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan informasi read-only
  Widget _buildReadOnlyInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk card info dengan tombol edit
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.edit_outlined, color: iconColor, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk opsi pengiriman
  Widget _buildShippingOption({
    required String label,
    required String description,
    required String price,
    required bool isSelected,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child:
                  isSelected
                      ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                          ),
                        ),
                      )
                      : const SizedBox(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Pengiriman $label',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? primaryColor.withOpacity(0.1)
                                  : Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          description,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? primaryColor : Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label == 'Standard'
                        ? 'Pengiriman reguler'
                        : 'Pengiriman cepat di hari yang sama',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isSelected ? primaryColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk gambar produk
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
