import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:indriver_clone/models/user.dart';

enum AuthState { loggedIn, loggedOut }

class Authentication with ChangeNotifier {
  AuthState _loginState = AuthState.loggedOut;
  get loginState => _loginState;
  UserModel loggedUser = UserModel();
  final _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

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
  register() {}
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
