import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/main.dart';
import 'package:mosques_donation_app/providers/app_provider.dart';
import 'package:mosques_donation_app/screens/languages/languages_screen.dart';
import 'package:mosques_donation_app/screens/tab_screens.dart';
import 'package:mosques_donation_app/services/http_service.dart';
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
  AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);

    Future.delayed(Duration(seconds: 5), () {
      _retrieveData();
    });
  }

  _retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    appProvider.setCategories(await HttpService.getCategories());
    appProvider.setBanners(await HttpService.getBanners());

    appProvider.setCurrentLanguage('English');
    MyApp.setLocale(context, Locale('en', 'US'), 'English');

    print(prefs.getBool('authenticated'));
    // bool autenticated = prefs.getBool('authenticated') != null
    //     ? prefs.getBool('authenticated')
    //     : false;

    bool firstTime = prefs.getBool('first_time');
    if (firstTime == null) {
      firebaseCloudMessagingListeners();
      prefs.setBool('first_time', false);
    }

    bool autenticated = true;
    if (autenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TabsScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LanguagesScreen(nextEnabled: true),
        ),
      );
    }
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
