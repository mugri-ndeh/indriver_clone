import 'package:flutter/material.dart';

class RideRequests extends StatefulWidget {
  const RideRequests({Key? key}) : super(key: key);

  @override
  _RideRequestsState createState() => _RideRequestsState();
}

class _RideRequestsState extends State<RideRequests>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            Text('Searching for requests\n Distance 1km')
          ],
        ),
      ),
    );
  }
}
