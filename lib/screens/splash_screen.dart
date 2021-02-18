import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/main.dart';
import 'package:mosques_donation_app/providers/app_provider.dart';
import 'package:mosques_donation_app/providers/auth_provider.dart';
import 'package:mosques_donation_app/providers/cart_provider.dart';
import 'package:mosques_donation_app/screens/languages/languages_screen.dart';
import 'package:mosques_donation_app/screens/signin/signin_screen.dart';
import 'package:mosques_donation_app/screens/tab_screens.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/utils/session_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../size_config.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash_screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SessionManager sessionManager = SessionManager();
  AppProvider appProvider;
  CartProvider cartProvider;
  String userId;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    cartProvider = Provider.of<CartProvider>(context, listen: false);

    _retrieveData();
  }

  _retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String language = prefs.getString('language');
    if (language == 'English') {
      appProvider.setCurrentLanguage('English');
      MyApp.setLocale(context, Locale('en', 'US'), 'English');
    } else if (language == 'Arabic') {
      appProvider.setCurrentLanguage('Arabic');
      MyApp.setLocale(context, Locale('ar', 'AR'), 'Arabic');
    } else {
      appProvider.setCurrentLanguage('English');
      MyApp.setLocale(context, Locale('en', 'US'), 'English');
    }

    print('Retrieved Saved Language');

    appProvider.setSettings(await HttpService.getSettings());
    appProvider.setCategories(await HttpService.getCategories());
    appProvider.setBanners(await HttpService.getBanners());

    firebaseCloudMessagingListeners();
    print('Saved Device Token');

    bool loggedIn = await sessionManager.getLoggedIn();
    if (loggedIn) {
      AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);
      await sessionManager.getUser().then(
            (user) => sessionManager.getPassword().then((password) async {
              authProvider
                  .loginUser(context, user.phone, password)
                  .then((user) async {
                if (user != null)
                  _navigateToTabsScreen();
                else
                  _navigateToLoginScreen();
              });
              cartProvider
                  .setCartCount(await HttpService.getCartCount(user.id));
            }),
          );
    } else {
      print(language);
      if (language == null) {
        _navigateToLanguagesScreen();
      } else {
        _navigateToLoginScreen();
      }
    }
  }

  _navigateToTabsScreen() {
    Navigator.pushReplacementNamed(context, TabsScreen.routeName);
  }

  _navigateToLoginScreen() {
    Navigator.pushReplacementNamed(context, SignInScreen.routeName);
  }

  _navigateToLanguagesScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LanguagesScreen(nextEnabled: true),
      ),
    );
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      HttpService.addDevice(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {},
      onResume: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {},
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Text(
          'Mosques Donation',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
