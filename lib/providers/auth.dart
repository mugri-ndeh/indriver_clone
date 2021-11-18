import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indriver_clone/models/user.dart';
import 'package:indriver_clone/screens/account_details.dart';

enum AuthState { loggedIn, loggedOut }

class Authentication with ChangeNotifier {
  AuthState _loginState = AuthState.loggedOut;
  get loginState => _loginState;
  UserModel loggedUser = UserModel();
  final _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? verificationCode;

  Authentication() {
    init();
  }

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = AuthState.loggedIn;
      } else {
        _loginState = AuthState.loggedOut;
      }
      notifyListeners();
    });
    loggedUser = await returnUser();
    notifyListeners();
    print(loggedUser.email);
    print(loggedUser.username);
  }

  login(String phoneNumber) async {
    try {
      var auth = FirebaseAuth.instance;
      await auth.signInWithPhoneNumber(phoneNumber);
    } catch (e) {}
  }

  UserModel getUser(User? user) {
    return UserModel(id: user!.uid);
  }

  Stream<UserModel> onAuthStateChanged() {
    var auth = FirebaseAuth.instance;
    return auth.authStateChanges().map(getUser);
  }

  logout() {}
  Future<void> signin(String phoneNum, BuildContext context) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNum,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const CompleteSignUp(),
                  ),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message.toString()),
              duration: const Duration(seconds: 3),
            ),
          );
        },
        codeSent: (String vID, int? resendToken) {
          verificationCode = vID;
        },
        codeAutoRetrievalTimeout: (String vID) {
          verificationCode = vID;
        },
        timeout: const Duration(seconds: 60),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> register(String phoneNumber, BuildContext context) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber!,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const CompleteSignUp(),
                  ),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message.toString()),
              duration: const Duration(seconds: 3),
            ),
          );
        },
        codeSent: (String vID, int? resendToken) {
          verificationCode = vID;
        },
        codeAutoRetrievalTimeout: (String vID) {
          verificationCode = vID;
        },
        timeout: const Duration(seconds: 60),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  completeprofile() {}
  Future<UserModel> returnUser() async {
    User? currentUser = auth.currentUser;
    var user = new UserModel();
    try {
      var userDoc =
          await _firestore.collection("users").doc(currentUser!.uid).get();
      user = UserModel.fromSnapshot(userDoc);
    } catch (e) {
      print(e);
    }
    return user;
  }
}
