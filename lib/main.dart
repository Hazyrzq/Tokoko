import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import Providers
import 'providers/cart_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/auth_provider.dart'; // Provider baru untuk authentication
import 'providers/location_provider.dart';

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
import 'screens/main_screen.dart';
import 'screens/profile_update_screen.dart';
import 'screens/fruit_category_screen.dart';
import 'screens/drinks_category_screen.dart';
import 'screens/personalcare_category_screen.dart';
import 'screens/kitchen_ingredients_category_screen.dart';

void main() async {
  // Pastikan Flutter binding sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()), // Provider untuk auth
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MaterialApp(
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
          '/': (context) => const AuthWrapper(), // Wrapper untuk cek authentication
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/main': (context) => const MainScreen(),
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
          '/edit_profile': (context) => const ProfileUpdateScreen(),
          '/drink_category': (context) => const DrinksCategoryScreen(),
          '/kitchen_ingredients_category': (context) => const KitchenIngredientsCategoryScreen(),
          '/fruit_category': (context) => const FruitCategoryScreen(),
          '/personalcare_category': (context) => const PersonalcareCategoryScreen(),
        },
      ),
    );
  }
}

// Wrapper untuk mengecek status authentication
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading while checking auth state
        if (authProvider.isLoading) {
          return const SplashScreen();
        }

        // Show main app if user is logged in, otherwise show login
        if (authProvider.user != null) {
          return const MainScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}