import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF2D7BEE);
    final secondaryColor = const Color(0xFFFF8C00);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              const SizedBox(height: 16),
              
              // Profile card
              _buildProfileCard(context, primaryColor),
              
              const SizedBox(height: 24),

              // Account section header
              _buildSectionHeader(primaryColor, 'Account'),
              
              const SizedBox(height: 12),

              // Edit Profile
              _buildSettingItem(
                context,
                Icons.person_rounded,
                'Edit Profile',
                primaryColor,
                onTap: () {
                  Navigator.pushNamed(context, '/edit_profile');
                },
              ),

              // Profile Creator - keeping this option
              _buildSettingItem(
                context,
                Icons.create_rounded,
                'Profile Creator',
                primaryColor,
                onTap: () {
                  Navigator.pushNamed(context, '/creator_profile');
                },
              ),

              const SizedBox(height: 24),

              // More section header
              _buildSectionHeader(secondaryColor, 'More'),
              
              const SizedBox(height: 12),

              // Help - new item
              _buildSettingItem(
                context,
                Icons.help_outline_rounded,
                'Help',
                secondaryColor,
                onTap: () {
                  _showHelpDialog(context);
                },
              ),

              // Review App
              _buildSettingItem(
                context,
                Icons.star_rounded,
                'Review App',
                secondaryColor,
                onTap: () {
                  _launchAppReview(context);
                },
              ),

              // About App
              _buildSettingItem(
                context,
                Icons.info_rounded,
                'About App',
                secondaryColor,
                onTap: () {
                  Navigator.pushNamed(context, '/about');
                },
              ),

              // App version
              _buildAppVersionSection(primaryColor),

              const SizedBox(height: 24),

              // Log out button
              _buildLogoutButton(context),
              
              // Space for bottom bar
              const SizedBox(height: 80),
            ],
          ),
        ],
      ),
    );
  }
  
  // Widget untuk membangun kartu profil
  Widget _buildProfileCard(BuildContext context, Color primaryColor) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
            children: [
              // Profile image
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: _buildProfileImage(profileProvider, primaryColor),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileProvider.nama,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      profileProvider.email,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Removed edit button as requested
            ],
          ),
        );
      },
    );
  }

  // Widget untuk membangun gambar profil
  Widget _buildProfileImage(ProfileProvider profileProvider, Color primaryColor) {
    // Cek apakah foto profil adalah asset atau file lokal
    if (profileProvider.fotoProfilPath.startsWith('assets/')) {
      // Jika dari asset
      return Image.asset(
        profileProvider.fotoProfilPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return profileProvider.generateAvatar(
            size: 70, 
            backgroundColor: primaryColor
          );
        },
      );
    } else {
      // Jika dari file lokal
      return Image.file(
        File(profileProvider.fotoProfilPath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return profileProvider.generateAvatar(
            size: 70, 
            backgroundColor: primaryColor
          );
        },
      );
    }
  }
  
  // Widget untuk membangun item pengaturan
  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    Color iconColor, {
    VoidCallback? onTap,
    bool showBadge = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showBadge)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'New',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onTap: onTap,
      ),
    );
  }

  // Widget untuk membangun header section
  Widget _buildSectionHeader(Color color, String title) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Widget untuk membangun section versi aplikasi
  Widget _buildAppVersionSection(Color primaryColor) {
    return Center(
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/LogoTokoKu.png',
              width: 60,
              height: 60,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_bag_rounded,
                    size: 30,
                    color: primaryColor,
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Version 1.0.0',
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Function untuk menampilkan dialog help
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.help_outline_rounded,
                color: const Color(0xFFFF8C00),
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Help Center',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHelpItem(
                  'Getting Started',
                  'Learn the basics of navigating and using our app',
                  Icons.play_arrow_rounded,
                ),
                const Divider(),
                _buildHelpItem(
                  'Account Issues',
                  'Help with login, registration, and profile settings',
                  Icons.person_rounded,
                ),
                const Divider(),
                _buildHelpItem(
                  'Payment Problems',
                  'Assistance with payment methods and transactions',
                  Icons.payment_rounded,
                ),
                const Divider(),
                _buildHelpItem(
                  'Contact Support',
                  'Get in touch with our customer service team',
                  Icons.support_agent_rounded,
                ),
                const SizedBox(height: 20),
                Text(
                  'Frequently Asked Questions',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                _buildFAQItem('How do I reset my password?'),
                _buildFAQItem('How to update my shipping address?'),
                _buildFAQItem('Can I cancel my order?'),
                _buildFAQItem('How to track my order?'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D7BEE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  // Widget untuk item bantuan
  Widget _buildHelpItem(String title, String subtitle, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2D7BEE).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF2D7BEE),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      onTap: () {
        // Action for each help item
      },
    );
  }

  // Widget untuk item FAQ
  Widget _buildFAQItem(String question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: const Color(0xFFFF8C00),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              question,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function untuk review aplikasi
  void _launchAppReview(BuildContext context) {
    // Show a dialog to get user review
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double rating = 0;
        String review = '';
        
        return AlertDialog(
          title: Text(
            'Rate Our App',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your feedback helps us improve!',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Star rating
                StatefulBuilder(
                  builder: (context, setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => IconButton(
                          icon: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: const Color(0xFFFF8C00),
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              rating = index + 1;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Review text field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Write your review here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  maxLines: 4,
                  onChanged: (value) {
                    review = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Here you would typically send the review to your backend
                // or open the app store page for a review
                
                // For now, just show a thank you message
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Thanks for your feedback!',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: const Color(0xFF2D7BEE),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D7BEE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Submit',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  // Widget untuk membangun tombol logout
  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Handle logout
          Navigator.pushReplacementNamed(context, '/login');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: Colors.red[700],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Log out',
              style: GoogleFonts.poppins(
                color: Colors.red[700],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}