import 'package:flutter/material.dart';
import 'package:indriver_clone/ui/app_bar.dart';
import 'package:indriver_clone/ui/nav_drawer.dart';

class Support extends StatelessWidget {
  const Support({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: const NavAppbar(title: 'Support'),
    );
  }
}
