import 'package:flutter/material.dart';

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
    return Container();
  }
}
