import 'package:flutter/material.dart';
import 'package:indriver_clone/ui/app_bar.dart';

class Support extends StatelessWidget {
  const Support({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: const NavAppbar(title: 'Support'),
    );
  }
}
