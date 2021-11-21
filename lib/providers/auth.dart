import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indriver_clone/models/user.dart';
import 'package:indriver_clone/screens/account_details.dart';
import 'package:indriver_clone/screens/homepage.dart';

enum AuthState { loggedIn, loggedOut }

class Authentication with ChangeNotifier {
  AuthState _loginState = AuthState.loggedOut;
  get loginState => _loginState;
  UserModel loggedUser = UserModel();
  final _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? verificationCode;
  DatabaseReference db = FirebaseDatabase.instance.reference();

  Authentication() {
    init();
  }

  Future<void> init() async {
    auth.userChanges().listen((user) async {
      if (user != null) {
        _loginState = AuthState.loggedIn;
        //loggedUser.id = user.uid;
      } else {
        _loginState = AuthState.loggedOut;
      }
      notifyListeners();
    });
    loggedUser = await returnUser();

    notifyListeners();
    //print(loggedUser.email);
    //print(loggedUser.username);
  }

  UserModel? getUser(User? user) {
    return user == null ? null : UserModel(id: user.uid);
  }

  Stream<UserModel?> onAuthStateChanged() {
    return auth.authStateChanges().map(getUser);
  }

  logout() async {
    await auth.signOut();
    print('signed out');
    notifyListeners();
  }

//if user account exists, will be in firebase database
  Future<void> signin(String phoneNum, BuildContext context) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNum,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            await _firestore
                .collection('users')
                .where('id', isEqualTo: value.user!.uid)
                .get()
                .then((result) {
              if (result.docs.isEmpty) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CompleteSignUp(),
                    ),
                    (route) => false);
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                    (route) => false);
                notifyListeners();
              }
            });
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

  Future<void> completeprofile(String firstname, String lastname,
      String username, String dob, String email, context) async {
    Map<String, dynamic> usermap = {
      'id': auth.currentUser!.uid,
      'firstName': firstname,
      'phoneNumber': auth.currentUser!.phoneNumber,
      'username': username,
      'isOnline': false,
      'isDriver': false,
      'lastName': lastname,
      'email': email,
      'token': '',
      'photo': '',
      'licenceNo': '',
      'carplatenum': '',
      'idNo': '',
      'votes': 0,
      'trips': 0,
      'rating': 0.0,
      'dob': dob,
    };
    try {
      await _firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set(usermap)
          .then((value) async {
        loggedUser = await returnUser();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  updateProfile(String firstname, String lastname, String username, String dob,
      String email, context) async {
    Map<String, dynamic> usermap = {
      'id': loggedUser.id,
      'firstName': firstname,
      'phoneNumber': loggedUser.phoneNumber,
      'username': username,
      'lastName': lastname,
      'email': email,
      'dob': dob,
    };
    try {
      await _firestore.collection('users').doc(loggedUser.id).update(usermap);
      loggedUser = await returnUser();
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<UserModel> returnUser() async {
    User? currentUser = auth.currentUser;
    var user = UserModel();
    try {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get()
          .then((value) {
        user = UserModel.fromSnapshot(value);
      });
    } on FirebaseException catch (e) {
      print('nothing returned');
      print(e);
    }
    return user;
  }

  void setDriver() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'isDriver': true}).then((value) async {
      loggedUser = await returnUser();
    });
  }
}
