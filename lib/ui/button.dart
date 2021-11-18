import 'package:flutter/material.dart';
import 'package:indriver_clone/ui/constants.dart';

class BotButton extends StatefulWidget {
  const BotButton({Key? key, required this.onTap, required this.title})
      : super(key: key);

  final Function() onTap;
  final String title;

  @override
  State<BotButton> createState() => _BotButtonState();
}

class _BotButtonState extends State<BotButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          width: size.width * 0.9,
          child: Center(
            child: Text(
              widget.title,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          decoration: BoxDecoration(
              color: buttonColor, borderRadius: BorderRadius.circular(24)),
        ),
      ),
    );
  }
}
