import 'package:flutter/material.dart';
import 'package:mosques_donation_app/main.dart';
import 'package:mosques_donation_app/models/language.dart';
import 'package:mosques_donation_app/providers/app_provider.dart';
import 'package:mosques_donation_app/screens/languages/widgets/languages_list_item.dart';
import 'package:mosques_donation_app/screens/signup/signup_screen.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/default_button.dart';
import 'package:provider/provider.dart';

class LanguagesScreen extends StatefulWidget {
  static String routeName = "/languages_screen";

  final bool nextEnabled;

  const LanguagesScreen({Key key, this.nextEnabled}) : super(key: key);

  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  AppProvider appProvider;

  List<Language> _languages = [
    Language(name: 'English'),
    Language(name: 'Arabic'),
  ];

  Language _selectedLanguage;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    _selectedLanguage = _languages.firstWhere(
      (l) => l.name == appProvider.getLanguage(),
    );
  }

  _changeLanguage(String language) {
    Locale _temp;
    switch (language) {
      case 'English':
        _temp = Locale('en', 'US');
        MyApp.setLocale(context, _temp, 'English');
        Provider.of<AppProvider>(context, listen: false)
            .setCurrentLanguage(language);
        break;
      case 'Arabic':
        _temp = Locale('ar', 'AR');
        MyApp.setLocale(context, _temp, 'Arabic');
        Provider.of<AppProvider>(context, listen: false)
            .setCurrentLanguage(language);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trans(context, 'language'),
              style: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 3),
            Text(
              trans(context, 'please_enter_your_pref_lang'),
              style: TextStyle(
                color: Colors.black54,
                fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                fontWeight: FontWeight.normal,
              ),
            ),
            Container(
              height: SizeConfig.blockSizeVertical * 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _languages.length,
                  (i) => LanguagesListItem(
                    language: _languages[i],
                    selectedLanguage: _selectedLanguage,
                    onPressed: () {
                      setState(() {
                        _selectedLanguage = _languages[i];
                      });
                      _changeLanguage(_selectedLanguage.name);
                    },
                  ),
                ),
              ),
            ),
            widget.nextEnabled
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 6,
                    ),
                    child: DefaultButton(
                      press: () {
                        Navigator.pushNamed(context, SignUpScreen.routeName);
                      },
                      text: trans(context, 'next'),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
