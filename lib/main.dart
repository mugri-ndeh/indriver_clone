import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:indriver_clone/providers/handle.dart';
import 'package:indriver_clone/screens/otp_verification.dart';
import 'package:indriver_clone/screens/root.dart';
import 'package:indriver_clone/ui/button.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppHandler()),
        ChangeNotifierProvider(create: (context) => Authentication())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Root(),
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ScrollController? controller = ScrollController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller1 = TextEditingController();
  String? _platformVersion = 'Unknown';

  String initialCountry = 'NG';

  PhoneNumber _number = PhoneNumber(isoCode: 'NG');
  String? locale;

  final _formKey = GlobalKey<FormState>();

  Future<void> initPlatformState() async {
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterSimCountryCode.simCountryCode;
      print(platformVersion);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter your phone number to sign in',
                    style: TextStyle(fontSize: 22),
                  ),
                  InternationalPhoneNumberInput(
                    validator: (val) {
                      //print(val);
                      if (val!.isEmpty) {
                        return 'Field cannot be empty';
                      }
                    },
                    onInputChanged: (PhoneNumber number) {
                      // ignore: avoid_print
                      //print(number.phoneNumber);
                      setState(() {
                        _number = number;
                      });
                    },
                    onInputValidated: (bool value) {
                      // ignore: avoid_print
                      //print(value);
                    },
                    selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: const TextStyle(color: Colors.black),
                    initialValue: _number,
                    textFieldController: controller1,
                    formatInput: false,
                    maxLength: 12,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    onSaved: (PhoneNumber number) {
                      // ignore: avoid_print
                      //print('On Saved: $number');
                    },
                  ),
                  Column(
                    children: [
                      BotButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Verification(
                                  phoneNum: _number.phoneNumber!,
                                ),
                              ),
                            );
                            if (_formKey.currentState!.validate()) {
                              if (_number != null) {
                                print(_number.phoneNumber);
                              } else {
                                print('Enter a phone number');
                              }
                            }
                          },
                          title: 'Next'),
                      const Text(
                        'By tapping \"Next\" you agree to Terms and Conditions and Privacy Policy',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
