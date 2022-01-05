import 'package:flutter/material.dart';
import 'package:indriver_clone/driver/screens/main_page.dart';
import 'package:indriver_clone/models/user.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:provider/provider.dart';

import 'homepage.dart';

class StartScreen extends StatefulWidget {
  StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context, listen: false);
    return Container(
      child: auth.loggedUser.isDriver! ? MainDriverPage() : const HomePage(),
    );
  }
}
