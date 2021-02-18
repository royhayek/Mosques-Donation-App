import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/language.dart';
import 'package:mosques_donation_app/providers/app_provider.dart';
import 'package:mosques_donation_app/providers/auth_provider.dart';
import 'package:mosques_donation_app/screens/account/widgets/account_list_item.dart';
import 'package:mosques_donation_app/screens/donation_history/donation_history_screen.dart';
import 'package:mosques_donation_app/screens/information/information_screen.dart';
import 'package:mosques_donation_app/screens/signin/signin_screen.dart';
import 'package:mosques_donation_app/screens/suggestion/suggestion_report_screen.dart';
import 'package:mosques_donation_app/size_config.dart';
import 'package:mosques_donation_app/utils/session_manager.dart';
import 'package:mosques_donation_app/utils/utils.dart';
import 'package:mosques_donation_app/widgets/custom_switch.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_config.dart';
import '../../main.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AppProvider appProvider;

  List<Language> _languages = [
    Language(name: 'English'),
    Language(name: 'Arabic'),
  ];

  Language _selectedLanguage;
  bool switchstate;

  _launchURL(String imageUrl) async {
    if (await canLaunch(imageUrl)) {
      await launch(imageUrl);
    } else {
      throw 'Could not launch $imageUrl';
    }
  }

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    _selectedLanguage = _languages.firstWhere(
      (l) => l.name == appProvider.getLanguage(),
    );

    if (_selectedLanguage.name == 'English') {
      switchstate = true;
    } else {
      switchstate = false;
    }
  }

  _changeLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Locale _temp;
    switch (language) {
      case 'English':
        _temp = Locale('en', 'US');
        MyApp.setLocale(context, _temp, 'English');
        prefs.setString('language', 'English');
        Provider.of<AppProvider>(context, listen: false)
            .setCurrentLanguage(language);
        break;
      case 'Arabic':
        _temp = Locale('ar', 'AR');
        MyApp.setLocale(context, _temp, 'Arabic');
        prefs.setString('language', 'Arabic');
        Provider.of<AppProvider>(context, listen: false)
            .setCurrentLanguage(language);
        break;
    }
  }

  _logout(BuildContext context) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    SessionManager pref = SessionManager();
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.routeName,
      (route) => false,
    );
    await pref.cleaUser();
    await authProvider.clearUser();
  }

  _shareApp() {
    if (Platform.isAndroid) {
      Share.share('$SHARE_TEXT \n $ANDROID_SHARE_URL');
    } else if (Platform.isIOS) {
      Share.share('$SHARE_TEXT \n $IOS_SHARE_URL');
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
          horizontal: SizeConfig.blockSizeHorizontal * 7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trans(context, 'settings'),
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 7),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 2.5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => _launchURL(
                        'https://www.facebook.com/FlutterTutorial4U'),
                    child: ImageIcon(
                      AssetImage('assets/images/facebook.png'),
                      size: SizeConfig.blockSizeHorizontal * 8,
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
                SizedBox(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => _launchURL(
                        'https://www.instagram.com/flutter.developers'),
                    child: ImageIcon(
                      AssetImage('assets/images/instagram.png'),
                      size: SizeConfig.blockSizeHorizontal * 8,
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
                SizedBox(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => _launchURL('https://twitter.com/FlutterDev'),
                    child: ImageIcon(
                      AssetImage('assets/images/twitter.png'),
                      size: SizeConfig.blockSizeHorizontal * 8,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    AccountListItem(
                      title: trans(context, 'donation_history'),
                      icon: FluentIcons.history_24_regular,
                      onPressed: () => Navigator.pushNamed(
                        context,
                        DonationHistoryScreen.routeName,
                      ),
                    ),
                    AccountListItem(
                      title: trans(context, 'language'),
                      icon: FluentIcons.earth_24_regular,
                      end: CustomSwitch(
                        activeColor: Colors.pinkAccent,
                        value: switchstate,
                        language: switchstate ? 'EN' : 'AR',
                        onChanged: (value) {
                          print("VALUE : $value");
                          setState(() {
                            switchstate = value;
                          });
                          if (value)
                            _changeLanguage('English');
                          else
                            _changeLanguage('Arabic');
                        },
                      ),

                      // Switch(
                      //     value: switchstate,
                      //     onChanged: (value) {
                      //       setState(() {
                      //         switchstate = !switchstate;
                      //       });
                      //       if (value)
                      //         _changeLanguage('English');
                      //       else
                      //         _changeLanguage('Arabic');
                      //     }),
                      // onPressed: () => Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => LanguagesScreen(nextEnabled: false),
                      //   ),
                      // ),
                    ),
                    AccountListItem(
                      title: trans(context, 'complain_or_suggest'),
                      icon: FluentIcons.signature_24_regular,
                      onPressed: () => Navigator.pushNamed(
                        context,
                        SuggestionReportScreen.routeName,
                      ),
                    ),
                    appProvider.settings.privacyPolicyEnabled == 1
                        ? AccountListItem(
                            title: trans(context, 'privacy_policy'),
                            icon: FluentIcons.info_shield_20_regular,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformationScreen(
                                    title: trans(context, 'privacy_policy')),
                              ),
                            ),
                          )
                        : Container(),
                    appProvider.settings.termsAndConditionsEnabled == 1
                        ? AccountListItem(
                            title: trans(context, 'terms_and_conditions'),
                            icon: FluentIcons.reading_mode_mobile_20_regular,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformationScreen(
                                    title:
                                        trans(context, 'terms_and_conditions')),
                              ),
                            ),
                          )
                        : Container(),
                    appProvider.settings.aboutUsEnabled == 1
                        ? AccountListItem(
                            title: trans(context, 'about_us'),
                            icon: FluentIcons.info_16_regular,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformationScreen(
                                    title: trans(context, 'about_us')),
                              ),
                            ),
                          )
                        : Container(),
                    AccountListItem(
                      title: trans(context, 'share_app'),
                      icon: FluentIcons.share_20_regular,
                      onPressed: () => _shareApp(),
                    ),
                    AccountListItem(
                      title: trans(context, 'logout'),
                      icon: FluentIcons.sign_out_20_regular,
                      onPressed: () => _logout(context),
                      last: true,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
