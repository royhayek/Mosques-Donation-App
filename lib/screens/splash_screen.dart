import 'package:flutter/material.dart';
import 'package:mosques_donation_app/providers/app_provider.dart';
import 'package:mosques_donation_app/screens/otp/otp_screen.dart';
import 'package:provider/provider.dart';

import '../size_config.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash_screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    getLanguage();

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, OTPScreen.routeName);
    });
  }

  getLanguage() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.setCurrentLanguage('English');
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
