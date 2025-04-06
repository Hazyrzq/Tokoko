import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Import provider
import '../providers/cart_provider.dart';

// Import screen yang diperlukan
import 'home_screen.dart';  
import 'news_screen.dart';
import 'transaction_screen.dart';
import 'setting_screen.dart';
import '../widgets/navigationbar.dart';

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
    const NewsScreen(showBackButton: false), // Index 1 - tanpa tombol back
    const TransactionScreen(), // Index 2
    const SettingScreen(),    // Index 3
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Stack(
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
                backgroundColor: Colors.orange,
                child: const Icon(Icons.shopping_cart),
                elevation: 6,
                shape: const CircleBorder(),
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
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