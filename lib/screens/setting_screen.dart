import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF2D7BEE);
    final secondaryColor = const Color(0xFFFF8C00);
    final screenHeight = MediaQuery.of(context).size.height;

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
        // No back button
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
              Row(
                children: [
                  Container(
                    height: 24,
                    width: 4,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Account',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),

              // Creator Profile
              _buildSettingItem(
                context,
                Icons.person_rounded,
                'Creator Profile',
                primaryColor,
                onTap: () {
                  Navigator.pushNamed(context, '/creator_profile');
                },
              ),

              // Password
              _buildSettingItem(
                context,
                Icons.lock_rounded,
                'Password',
                primaryColor,
                onTap: () {
                  // Navigate to password screen when implemented
                },
              ),

              // Shipping Address
              _buildSettingItem(
                context,
                Icons.location_on_rounded,
                'Shipping Address',
                primaryColor,
                onTap: () {
                  // Navigate to shipping address screen when implemented
                },
                showBadge: true,
              ),

              // Notifications
              _buildSettingItem(
                context,
                Icons.notifications_rounded,
                'Notifications',
                primaryColor,
                onTap: () {
                  // Navigate to notifications screen when implemented
                },
                showToggle: true,
              ),

              const SizedBox(height: 24),

              // More section header
              Row(
                children: [
                  Container(
                    height: 24,
                    width: 4,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'More',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),

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

              // Help
              _buildSettingItem(
                context,
                Icons.help_rounded,
                'Help & Support',
                secondaryColor,
                onTap: () {
                  // Navigate to help screen when implemented
                },
              ),
              
              // Theme
              _buildSettingItem(
                context,
                Icons.brightness_6_rounded,
                'Dark Mode',
                secondaryColor,
                showToggle: true,
              ),

              const SizedBox(height: 32),

              // App version
              Center(
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
              ),

              const SizedBox(height: 24),

              // Log out button
              Container(
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
              ),
              
              // Space for bottom bar
              const SizedBox(height: 80),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfileCard(BuildContext context, Color primaryColor) {
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
              child: Image.asset(
                'assets/images/profile_avatar.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return CircleAvatar(
                    backgroundColor: primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person_rounded,
                      color: primaryColor,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelompok 2',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'ezpzgeming@gmail.com',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Edit button
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.edit_rounded,
                color: primaryColor,
                size: 18,
              ),
              onPressed: () {
                // Handle edit profile
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    Color iconColor, {
    VoidCallback? onTap,
    bool showBadge = false,
    bool showToggle = false,
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
        trailing: showToggle
            ? Switch(
                value: title == 'Notifications', // For demonstration
                onChanged: (value) {},
                activeColor: iconColor,
              )
            : Row(
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
}