import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mosques_donation_app/models/user.dart';
import 'package:mosques_donation_app/services/http_service.dart';
import 'package:mosques_donation_app/utils/session_manager.dart';

class AuthProvider with ChangeNotifier {
  User _user = User();

  User get user {
    return _user;
  }

  Future<bool> setUser(User user) async {
    this._user = user;
    notifyListeners();
    return true;
  }

  Future clearUser() async {
    this._user = null;
    notifyListeners();
  }

  Future<User> loginUser(
      BuildContext context, String phone, String password) async {
    SessionManager prefs = SessionManager();
    User user = await HttpService.loginUser(
      context,
      phone: phone,
      password: password,
    );
    if (user != null) {
      if (user.status == 1) {
        await prefs.setLoggedIn(true);
        await prefs.setPassword(password);
        await prefs.setUser(user);
        return user;
      } else {
        Fluttertoast.showToast(
          msg: 'You account has been disabled',
        );
        return null;
      }
    }
    return null;
  }

  Future getUserInfo(BuildContext context, int userId) async {
    SessionManager prefs = SessionManager();
    User user = await HttpService.getUserInfo(context, userId: userId);
    if (user != null) {
      print(user.name);
      await prefs.setUser(user);
      this._user = user;
      notifyListeners();
    }
  }
}
