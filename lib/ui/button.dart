import 'package:flutter/material.dart';

class BotButton extends StatelessWidget {
  const BotButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
    );
  }
}
