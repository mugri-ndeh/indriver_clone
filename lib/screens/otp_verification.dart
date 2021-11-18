import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:indriver_clone/screens/account_details.dart';
import 'package:indriver_clone/screens/homepage.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key, required this.phoneNum}) : super(key: key);
  final String phoneNum;

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? verificationCode;

  final pinDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: const [
      BoxShadow(offset: Offset(0, 0.1), color: Colors.green, blurRadius: 4)
    ],
    borderRadius: BorderRadius.circular(10.0),
  );

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  void verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNum,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) {
            if (value.user != null) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (c) => const CompleteSignUp()),
              );
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
          setState(() {
            verificationCode = vID;
          });
        },
        codeAutoRetrievalTimeout: (String vID) {
          setState(() {
            verificationCode = vID;
          });
        },
        timeout: const Duration(seconds: 60));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    verifyPhoneNumber();
                  },
                  child: Text('Verifying : ${widget.phoneNum}'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: PinPut(
                fieldsCount: 6,
                eachFieldHeight: 55.0,
                eachFieldWidth: 40.0,
                focusNode: _focusNode,
                controller: _pinController,
                submittedFieldDecoration: pinDecoration,
                selectedFieldDecoration: pinDecoration,
                followingFieldDecoration: pinDecoration,
                pinAnimationType: PinAnimationType.rotation,
                onSubmit: (pin) async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(
                      PhoneAuthProvider.credential(
                          verificationId: verificationCode!, smsCode: pin),
                    )
                        .then((value) {
                      if (value.user != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (c) => HomePage()),
                        );
                      }
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('invalid pin'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
