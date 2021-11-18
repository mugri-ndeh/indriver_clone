import 'package:flutter/material.dart';
import 'package:indriver_clone/ui/constants.dart';

class Ratings extends StatefulWidget {
  Ratings({Key? key}) : super(key: key);

  @override
  _RatingsState createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 200,
                  width: size.width * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: primaryColor,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5),
              ),
              Center(
                child: Container(
                  height: 100,
                  width: size.width * 0.95,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
