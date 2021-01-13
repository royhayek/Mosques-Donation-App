import 'package:flutter/widgets.dart';
import 'package:mosques_donation_app/screens/cart/cart_screen.dart';
import 'package:mosques_donation_app/screens/cart_categories/cart_categories_screen.dart';
import 'package:mosques_donation_app/screens/categories/categories_screen.dart';
import 'package:mosques_donation_app/screens/checkout%202/checkout_2_screen.dart';
import 'package:mosques_donation_app/screens/checkout/checkout_screen.dart';
import 'package:mosques_donation_app/screens/donation_history/donation_history_screen.dart';
import 'package:mosques_donation_app/screens/languages/languages_screen.dart';
import 'package:mosques_donation_app/screens/products_list/products_list_screen.dart';
import 'package:mosques_donation_app/screens/signup/signup_screen.dart';

import 'package:mosques_donation_app/screens/splash_screen.dart';
import 'package:mosques_donation_app/screens/subcategories/subcategories_screen.dart';
import 'package:mosques_donation_app/screens/suggestion/suggestion_report_screen.dart';
import 'package:mosques_donation_app/screens/tab_screens.dart';
import 'package:mosques_donation_app/screens/otp/otp_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  LanguagesScreen.routeName: (context) => LanguagesScreen(),
  OTPScreen.routeName: (context) => OTPScreen(),
  TabsScreen.routeName: (context) => TabsScreen(),
  CategoriesScreen.routeName: (context) => CategoriesScreen(),
  SubCategoriesScreen.routeName: (context) => SubCategoriesScreen(),
  ProductsListScreen.routeName: (context) => ProductsListScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  CartCategoriesScreen.routeName: (context) => CartCategoriesScreen(),
  DonationHistoryScreen.routeName: (context) => DonationHistoryScreen(),
  SuggestionReportScreen.routeName: (context) => SuggestionReportScreen(),
  CheckoutScreen.routeName: (context) => CheckoutScreen(),
  Checkout2Screen.routeName: (context) => Checkout2Screen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
};
