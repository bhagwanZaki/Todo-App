import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String username;
  String email;
  String fullname;

  AuthProvider({this.email = "", this.fullname = "", this.username = ""});

  void setUsername(String data) {
    username = data;
    notifyListeners();
  }

  void setFullname(String data) {
    fullname = data;
    notifyListeners();
  }

  void setEmail(String data) {
    email = data;
    notifyListeners();
  }

  void clear() {
    email = "";
    username = "";
    fullname = "";

    notifyListeners();
  }
}
