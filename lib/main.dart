import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import semua screen
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/food_category_screen.dart';
import 'screens/news_screen.dart';
import 'screens/transaction_screen.dart';
import 'screens/setting_screen.dart';
import 'screens/creator_profile_screen.dart';
import 'screens/about_screen.dart';
import 'screens/detail_promo_screen.dart';
import 'screens/cart_screen.dart'; 
import 'screens/checkout_screen.dart'; 
import 'screens/main_screen.dart'; // Tambahkan import untuk MainScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokoKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2D7BEE),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF2D7BEE),
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D7BEE),
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainScreen(), // Tambahkan route untuk MainScreen
        '/home': (context) => const HomeScreen(),
        '/food_category': (context) => const FoodCategoryScreen(),
        '/news': (context) => const NewsScreen(),
        '/transaction': (context) => const TransactionScreen(),
        '/setting': (context) => const SettingScreen(),
        '/creator_profile': (context) => const CreatorProfileScreen(),
        '/about': (context) => const AboutScreen(),
        '/detail_promo': (context) => const DetailPromoScreen(),
        '/cart': (context) => const CartScreen(),
        '/checkout': (context) => const CheckoutScreen(),
      },
    );
  }
}