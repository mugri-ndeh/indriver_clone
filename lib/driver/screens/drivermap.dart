import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indriver_clone/driver/screens/waiting_screen.dart';
import 'package:indriver_clone/models/requests.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:indriver_clone/providers/handle.dart';
import 'package:indriver_clone/ui/button.dart';
import 'package:indriver_clone/util/assistant_methods.dart';
import 'package:provider/provider.dart';

class DriverMap extends StatefulWidget {
  DriverMap({Key? key, required this.request}) : super(key: key);

  final RideRequest request;

  @override
  _DriverMapState createState() => _DriverMapState();
}

class _DriverMapState extends State<DriverMap> {
  final _formKey = GlobalKey<FormState>();
  var minutesController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<AppHandler>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: size.height * 0.7,
              child: GoogleMap(
                //onTap: _mapTapped,
                mapType: MapType.normal,
                myLocationEnabled: true,
                markers: markersSet,
                circles: circlesSet,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(widget.request.startLat!),
                      double.parse(widget.request.startLong!)),
                  zoom: 14.0,
                ),
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                polylines: polylineSet,
              ),
            ),
            ListTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('New Request'),
                  Text('From: ' + widget.request.startAddress!),
                  Text('To: ' + widget.request.endAddress!),
                ],
              ),
              subtitle:
                  Text('Amount offered: ' + widget.request.price! + 'KES'),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: minutesController,
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      val!.isEmpty ? 'Please input time in minutes' : null,
                  decoration: const InputDecoration(
                      hintText: 'Enter minutes for you to reach user'),
                ),
              ),
            ),
            BotButton(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    var user =
                        Provider.of<Authentication>(context, listen: false)
                            .loggedUser;
                    print('Accepted');
                    if (user.submittedStatus == 'verified' &&
                        user.token == 'OK') {
                      provider.acceptRequest(
                          widget.request.id, context, minutesController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Waiting(),
                        ),
                      );
                    } else if (user.submittedStatus == '') {
                      //tell to submit docs
                      showAlert(
                          'Please Submit your documents to continue', size);
                    } else if (user.submittedStatus == 'waiting') {
                      //tell user to wait for doc verification
                      showAlert(
                          'Your documents are in processing. It might take a while plaese hold on',
                          size);
                    } else if (user.token == 'suspended') {
                      // tell the user their account has been blocked and cant work no more
                      showAlert(
                          'Your account has been suspended. Please logout and create a new one that doesnt violate our privacy policies',
                          size);
                    }
                  }
                  //provider.acceptRequest(index, context);
                },
                title: 'Accept')
          ],
        ),
      ),
    );
  }

  void showAlert(String message, Size size) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 150,
          width: size.width * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Please select a drop off location'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    newController = controller;
    getDirection(context, widget.request.startLat!, widget.request.startLong!,
        widget.request.endLat!, widget.request.endLong!, newController);
  }

  // ignore: unused_field, prefer_final_fields
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController newController;

  List<LatLng> pLineCoordinates = [];
  //geolocaor
  var geolocator = Geolocator();

  //polylines to draw points
  Set<Polyline> polylineSet = {};
  Set<Circle> circlesSet = {};
  Set<Marker> markersSet = {};

  Future<void> getDirection(
      BuildContext context,
      String startLat,
      String startLong,
      String endLat,
      String endLong,
      GoogleMapController mapController) async {
    var startLngLat = LatLng(double.parse(startLat), double.parse(startLong));
    var endLatLng = LatLng(double.parse(endLat), double.parse(endLong));

    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    var details = await AssistantMethods.getDirectiondetials(
        startLngLat, endLatLng, context);
    Navigator.pop(context);

    print('This are the encoded points');
    print(details!.encodedPoints!);

    PolylinePoints polylinePoints = PolylinePoints();

    List<PointLatLng> decodedPoints =
        polylinePoints.decodePolyline(details.encodedPoints!);

    //clear before drawing new lines
    setState(() {
      pLineCoordinates.clear();
    });

    if (decodedPoints.isNotEmpty) {
      for (var pointLatLng in decodedPoints) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    //clear nefore drawing directions
    setState(() {
      polylineSet.clear();
    });

//line to be drawn properties
    Polyline polyline = Polyline(
        polylineId: const PolylineId('PolylineID'),
        color: Colors.red,
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true);

//draw line
    setState(() {
      polylineSet.add(polyline);
    });

// reanimate when drawing lines, ie zooom out of camera
    LatLngBounds latLngBounds;
    if (startLngLat.latitude > endLatLng.latitude &&
        startLngLat.longitude > endLatLng.longitude) {
      latLngBounds = LatLngBounds(southwest: endLatLng, northeast: startLngLat);
    } else if (startLngLat.latitude > endLatLng.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(endLatLng.latitude, startLngLat.longitude),
        northeast: LatLng(startLngLat.latitude, endLatLng.longitude),
      );
    } else if (startLngLat.longitude > endLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(startLngLat.latitude, endLatLng.longitude),
        northeast: LatLng(endLatLng.latitude, startLngLat.longitude),
      );
    } else {
      latLngBounds = LatLngBounds(southwest: startLngLat, northeast: endLatLng);
    }

//update screen with changes
    mapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

//draw markers
    Marker startMarker = Marker(
      markerId: MarkerId('StartId'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      //infoWindow:
      //  InfoWindow(title: initialPosition.placeName, snippet: 'My location'),
      position: startLngLat,
    );

    Marker endMarker = Marker(
      markerId: MarkerId('EndId'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      //infoWindow: InfoWindow(title: initialPosition.placeName, snippet: 'Destination'),
      position: endLatLng,
    );

    setState(() {
      markersSet.add(startMarker);

      markersSet.add(endMarker);
    });

    Circle startCircle = Circle(
      fillColor: Colors.yellow,
      center: startLngLat,
      radius: 12,
      strokeColor: Colors.yellowAccent,
      strokeWidth: 4,
      circleId: const CircleId('StartId'),
    );

    Circle endCircle = Circle(
      fillColor: Colors.blue,
      center: endLatLng,
      radius: 12,
      strokeColor: Colors.blueAccent,
      strokeWidth: 4,
      circleId: const CircleId('EndId'),
    );
    setState(() {
      circlesSet.add(startCircle);

      circlesSet.add(endCircle);
    });
  }
}
