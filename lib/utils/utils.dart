import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mosques_donation_app/providers/app_provider.dart';
import 'package:mosques_donation_app/translation/app_localizations.dart';
import 'package:provider/provider.dart';

String trans(BuildContext context, String text) {
  String translated;
  translated = AppLocalizations.of(context).translate(text);
  return translated;
}

bool isEnglish(BuildContext context) {
  AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
  return appProvider.getLanguage() == 'English';
}
