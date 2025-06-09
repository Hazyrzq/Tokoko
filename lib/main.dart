import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import Providers
import 'providers/cart_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/auth_provider.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

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
        ChangeNotifierProvider(create: (context) => AuthProvider()),
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
        // UBAH: Start langsung dengan splash screen
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/': (context) => const AuthWrapper(),
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

// DIPERBAIKI: AuthWrapper yang tidak tergantung splash screen
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Jika masih loading, tampilkan loading indicator
        if (authProvider.isLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF2D7BEE),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Checking authentication...',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Jika user sudah login, ke main screen
        if (authProvider.isAuthenticated) {
          return const MainScreen();
        } else {
          // Jika belum login, ke login screen
          return const LoginScreen();
        }
      },
    );
  }
}