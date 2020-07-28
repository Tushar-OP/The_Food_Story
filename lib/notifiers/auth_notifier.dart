import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:thefoodstory/models/user.dart';

class AuthNotifier with ChangeNotifier {
  FirebaseUser _user;
  User _userDetails;

  FirebaseUser get user => _user;

  setFirebaseUser(FirebaseUser user) {
    _user = user;
    notifyListeners();
  }

  User get userDetails => _userDetails;

  setUser(User user) {
    _userDetails = user;
    notifyListeners();
  }
}
