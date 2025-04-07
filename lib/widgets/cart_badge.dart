import 'package:flutter/material.dart';
import '../services/cart_service.dart';

class CartBadge extends StatelessWidget {
  final Widget child;
  final Color badgeColor;
  final Color textColor;
  
  const CartBadge({
    Key? key,
    required this.child,
    this.badgeColor = Colors.orange,
    this.textColor = Colors.white,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Use the CartService singleton
    final cartService = CartService();
    
    return AnimatedBuilder(
      animation: cartService,
      builder: (context, _) {
        final itemCount = cartService.itemCount;
        
        return Stack(
          clipBehavior: Clip.none, // Allow badge to overflow outside parent
          children: [
            child,
            if (itemCount > 0)
              Positioned(
                right: -5, // Position slightly to the right
                top: -5,   // Position slightly to the top
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red, // Changed to red to match screenshot
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      itemCount.toString(),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}