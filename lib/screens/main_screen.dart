import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// Import screen yang diperlukan - sesuaikan dengan nama file Anda yang sebenarnya
import 'home_screen.dart';
import 'news_screen.dart';
import 'transaction_screen.dart';
import 'setting_screen.dart';
import '../widgets/navigationbar.dart'; // Sesuaikan dengan lokasi file navigationbar.dart
import '../widgets/cart_badge.dart'; // Import cart badge widget
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan
  final List<Widget> _screens = [
    const HomeScreen(),       // Index 0
    const NewsScreen(),       // Index 1
    const TransactionScreen(), // Index 2
    const SettingScreen(),    // Index 3
  ];

  @override
  void initState() {
    super.initState();
    // Initialize profile data when MainScreen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProfileData();
    });
  }

  void _initializeProfileData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    // If user is authenticated and profile not loaded, initialize with Firebase user data
    if (authProvider.isAuthenticated && authProvider.user != null) {
      profileProvider.initializeWithUser(authProvider.user!);
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // If not authenticated, redirect to login
        if (!authProvider.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
                  (route) => false,
            );
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            backgroundColor: Colors.orange,
            // Add cart badge to FAB
            child: CartBadge(
              badgeColor: const Color(0xFF2D7BEE),
              child: const Icon(Icons.shopping_cart),
            ),
            elevation: 6,
            shape: const CircleBorder(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 6.0,
            color: const Color(0xFF2D7BEE),
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Dua item kiri
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _onNavItemTapped(0),
                            child: NavItem(
                              icon: Icons.home,
                              label: "Home",
                              selected: _selectedIndex == 0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _onNavItemTapped(1),
                            child: NavItem(
                              icon: Icons.notifications_none,
                              label: "News",
                              selected: _selectedIndex == 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Ruang untuk FAB
                  const SizedBox(width: 60),

                  // Dua item kanan
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _onNavItemTapped(2),
                            child: NavItem(
                              icon: Icons.receipt_long,
                              label: "Orders",
                              selected: _selectedIndex == 2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _onNavItemTapped(3),
                            child: NavItem(
                              icon: Icons.person_outline,
                              label: "Setting",
                              selected: _selectedIndex == 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const NavItem({
    Key? key,
    required this.icon,
    required this.label,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: selected ? Colors.white : Colors.white70,
          size: 22,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: selected ? Colors.white : Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}