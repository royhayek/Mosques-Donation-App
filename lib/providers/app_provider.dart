import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  String language;

  void setCurrentLanguage(String language) {
    this.language = language;
    notifyListeners();
  }

  String getLanguage() {
    return language;
  }
}
