import 'package:flutter/widgets.dart';
import 'package:mosques_donation_app/screens/cart/cart_screen.dart';
import 'package:mosques_donation_app/screens/categories/categories_screen.dart';
import 'package:mosques_donation_app/screens/languages/languages_screen.dart';
import 'package:mosques_donation_app/screens/subcategories/subcategories_screen.dart';

import 'package:mosques_donation_app/screens/splash_screen.dart';
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
  CartScreen.routeName: (context) => CartScreen(),
};
