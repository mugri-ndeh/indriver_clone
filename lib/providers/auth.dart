import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Authentication with ChangeNotifier {
  login(String phoneNumber) async {
    try {
      var auth = FirebaseAuth.instance;
      await auth.signInWithPhoneNumber(phoneNumber);
    } catch (e) {}
  }

  logout() {}
  register() {}
  completeprofile() {}
}
