import 'package:flutter/material.dart';
import 'package:mosques_donation_app/main.dart';
import 'package:mosques_donation_app/providers/app_provider.dart';
import 'package:mosques_donation_app/screens/languages/languages_screen.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:provider/provider.dart';
import '../size_config.dart';

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LanguagesScreen(nextEnabled: true),
        ),
      );
    });
  }

  _retrieveData() async {
    appProvider.setCurrentLanguage('English');
    MyApp.setLocale(context, Locale('en', 'US'), 'English');

    appProvider.setCategories(await HttpService.getCategories());

    appProvider.setBanners(await HttpService.getBanners());
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
