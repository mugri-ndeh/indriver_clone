import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indriver_clone/screens/homepage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
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

  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  String? locale;

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

  void getPhoneNumber() async {
    // PhoneNumber number =
    //     await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');
    //locale = await Devicelocale.currentLocale;
    Locale myLocale = Localizations.localeOf(context);
    print(myLocale);
    //print(locale);

    setState(() {
      this.number = number;
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
          child: Container(
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
                  onInputChanged: (PhoneNumber number) {
                    // ignore: avoid_print
                    print(number.phoneNumber);
                  },
                  onInputValidated: (bool value) {
                    // ignore: avoid_print
                    print(value);
                  },
                  selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DIALOG),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  initialValue: number,
                  textFieldController: controller1,
                  formatInput: false,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  onSaved: (PhoneNumber number) {
                    // ignore: avoid_print
                    print('On Saved: $number');
                  },
                ),
                Container(
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          },
                          child: const Text('Next')),
                      const Text(
                        'By tapping \"Next\" you agree to Terms and Conditions and Privacy Policy',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
