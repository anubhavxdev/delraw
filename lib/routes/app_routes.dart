import 'package:flutter/material.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/shopping_cart_screen/shopping_cart_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/checkout_screen/checkout_screen.dart';
import '../presentation/product_catalog_screen/product_catalog_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String dashboard = '/dashboard-screen';
  static const String splash = '/splash-screen';
  static const String shoppingCart = '/shopping-cart-screen';
  static const String login = '/login-screen';
  static const String checkout = '/checkout-screen';
  static const String productCatalog = '/product-catalog-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    dashboard: (context) => const DashboardScreen(),
    splash: (context) => const SplashScreen(),
    shoppingCart: (context) => const ShoppingCartScreen(),
    login: (context) => const LoginScreen(),
    checkout: (context) => const CheckoutScreen(),
    productCatalog: (context) => const ProductCatalogScreen(),
    // TODO: Add your other routes here
  };
}
