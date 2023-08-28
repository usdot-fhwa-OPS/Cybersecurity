import 'package:flutter/material.dart';

//TODO: additional login rules will need to be applied eventually. 30 day limit for stored credentials, etc
/// The login information.
class LoginInfo extends ChangeNotifier {
  
  static final LoginInfo _singleton = LoginInfo._internal();
  factory LoginInfo() {
    return _singleton;
  }
  LoginInfo._internal();

  /// The username of login.
  String get userName => _userName;
  String _userName = '';

  /// Whether a user has logged in.
  bool get loggedIn => _userName.isNotEmpty;

  /// Logs in a user.
  void login(String userName) {
    _userName = userName;
    notifyListeners();
  }

  /// Logs out the current user.
  void logout() {
    _userName = '';
    notifyListeners();
  }
}