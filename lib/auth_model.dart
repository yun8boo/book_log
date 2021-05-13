import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  User _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getUser() {
    final User _currentUser = _auth.currentUser;

    if (_auth.currentUser != null) {
      _user = _currentUser;
      notifyListeners();
    }
  }
}
