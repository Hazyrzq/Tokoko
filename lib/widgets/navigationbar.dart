import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  
  const CustomBottomNavBar({
    Key? key, 
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: const Color(0xFF2D7BEE), // Warna biru dari splash screen Anda
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
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: NavItem(
                        icon: Icons.home, 
                        label: "Home", 
                        selected: selectedIndex == 0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/news');
                      },
                      child: NavItem(
                        icon: Icons.notifications_none, 
                        label: "News",
                        selected: selectedIndex == 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Ruang untuk FAB
            SizedBox(width: 60),
            
            // Dua item kanan
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/transaction');
                      },
                      child: NavItem(
                        icon: Icons.receipt_long, 
                        label: "Trx", // Disingkat
                        selected: selectedIndex == 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/setting');
                      },
                      child: NavItem(
                        icon: Icons.person_outline, 
                        label: "Setting",
                        selected: selectedIndex == 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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