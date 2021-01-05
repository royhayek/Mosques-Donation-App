import 'package:flutter/material.dart';
import 'package:mosques_donation_app/models/banner.dart' as b;
import 'package:mosques_donation_app/models/category.dart';

class AppProvider with ChangeNotifier {
  String language;
  List<Category> categories;
  List<b.Banner> banners;

  void setCurrentLanguage(String language) {
    this.language = language;
  }

  String getLanguage() {
    return language;
  }

  void setCategories(List<Category> c) {
    this.categories = c;
  }

  List<Category> getCategories() {
    return categories;
  }

  void setBanners(List<b.Banner> b) {
    this.banners = b;
  }

  List<b.Banner> getBanners() {
    return banners;
  }

  notifyListeners();
}
