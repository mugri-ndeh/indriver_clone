import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indriver_clone/models/address.dart';
import 'package:indriver_clone/models/place_predications.dart';
import 'package:indriver_clone/models/requests.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:indriver_clone/util/assistant_methods.dart';
import 'package:indriver_clone/util/config.dart';
import 'package:indriver_clone/util/request_assist.dart';
import 'package:provider/provider.dart';

class AppHandler with ChangeNotifier {
  void init(context) {
    locatePosition(context);
    notifyListeners();
  }

  var _firestore = FirebaseFirestore.instance;
  var auth = FirebaseAuth.instance;
  RideRequest request = RideRequest();

  Address? pickupLocation, destinationLocation;
  var predictionList = [];
  var dummy;

  bool startSelected = false;
  bool endSelected = false;

  var startpoint = 'Start point';
  var endpoint = 'End point';

  //mapcontroller
  late GoogleMapController mapController;

  //currentlocation
  Position? liveLocation;

  //Coordinates to draw lines
  List<LatLng> pLineCoordinates = [];

  //geolocaor
  var geolocator = Geolocator();

  //polylines to draw points
  Set<Polyline> polylineSet = {};
  Set<Circle> circlesSet = {};
  Set<Marker> markersSet = {};

  //called everytime app starts
  void locatePosition(context) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    liveLocation = position;
    notifyListeners();

    LatLng liveposition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: liveposition, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    notifyListeners();

    String address =
        await AssistantMethods.searchCoordinateAdress(position, context);
    print('This is your adress: ' + address);
  }

  //update pickup when new position selected
  void updatePickupLocationAdress(Address pickupAddress) {
    pickupLocation = pickupAddress;
    startpoint = pickupLocation!.placeName!;
    startSelected = true;
    notifyListeners();
  }

  //update destination when new position selected
  void updateDestinationLocationAdress(Address destinationAddress) {
    destinationLocation = destinationAddress;
    endpoint = destinationLocation!.placeName!;
    endSelected = true;
    notifyListeners();
  }

//search autocomplete response
  findPlace(String placename) async {
    if (placename.length > 1) {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placename&types=geocode&key=${Config.api_key}&sessiontoken=1234567890";

      var result = await RequestAssistant.getRequest(url);

      if (result == 'failed') {
        print('There is an error');
      } else {
        print('Prediction response');
        print(result);
      }

      if (result['status'] == 'OK') {
        var predictions = result['predictions'];

        predictionList =
            (predictions as List).map((e) => Prediction.fromJson(e)).toList();

        notifyListeners();
      }
    }
  }

//get directions between points
  Future<void> getDirection(BuildContext context) async {
    var initialPosition = pickupLocation;
    var finalPosition = destinationLocation;

    var startLngLat =
        LatLng(initialPosition!.latitude!, initialPosition.longitude!);
    var endLatLng = LatLng(finalPosition!.latitude!, finalPosition.longitude!);

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
    pLineCoordinates.clear();

    if (decodedPoints.isNotEmpty) {
      for (var pointLatLng in decodedPoints) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
        notifyListeners();
      }
    }

    //clear nefore drawing directions
    polylineSet.clear();
    notifyListeners();

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
    polylineSet.add(polyline);
    notifyListeners();
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
    notifyListeners();

//draw markers
    Marker startMarker = Marker(
      markerId: MarkerId('StartId'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow:
          InfoWindow(title: initialPosition.placeName, snippet: 'My location'),
      position: startLngLat,
    );

    Marker endMarker = Marker(
      markerId: MarkerId('EndId'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow:
          InfoWindow(title: finalPosition.placeName, snippet: 'Destination'),
      position: endLatLng,
    );

    markersSet.add(startMarker);
    notifyListeners();
    markersSet.add(endMarker);
    notifyListeners();

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
    circlesSet.add(startCircle);
    notifyListeners();
    circlesSet.add(endCircle);
    notifyListeners();
  }

  bool requesting = false;
  bool deleted = false;

  void sendRequest(
    String startLat,
    String startLong,
    bool accepted,
    String username,
    String timeCreated,
    String phoneNum,
    String startAddress,
    String endAddress,
    String endLat,
    String endLong,
    String price,
  ) async {
    requesting = true;
    deleted = false;
    Map<String, dynamic> rideinfo = {
      'id': auth.currentUser!.uid,
      'startLat': startLat,
      'startLong': startLong,
      'endLat': endLat,
      'endLong': endLong,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'price': price,
      'accepted': accepted,
      'username': username,
      'phoneNum': phoneNum,
      'timeCreated': timeCreated,
      'driverId': '',
      'driverArrived': false,
      'driverName': '',
      'driverPic': '',
      'arrivalTime': '',
      'answered': false,
      'driverAccepted': false,
      'journeyStarted': false,
    };

    try {
      await _firestore
          .collection('request')
          .doc(auth.currentUser!.uid)
          .set(rideinfo)
          .then((value) async {
        await _firestore
            .collection('request')
            .doc(auth.currentUser!.uid)
            .get()
            .then((value) {
          request = RideRequest.fromDocument(value);
          getRequests();
          notifyListeners();
        });
        requesting = false;
        print('successs');
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> removeRequest() async {
    try {
      await _firestore
          .collection('request')
          .doc(auth.currentUser!.uid)
          .delete()
          .then((value) {
        deleted = true;
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  List<RideRequest> requests = [];
  void getRequests() async {
    await FirebaseFirestore.instance
        .collection('request')
        .where('accepted', isEqualTo: false)
        .get()
        .then((value) {
      requests = (value.docs).map((e) => RideRequest.fromDocument(e)).toList();
      notifyListeners();
      //print(requests[0].username);
    });
    notifyListeners();
    //print(requests[0].username);
  }

  void acceptRequest(id, context, time) async {
    var currentUser = Provider.of<Authentication>(context, listen: false);
    await FirebaseFirestore.instance.collection('request').doc(id).update({
      'driverAccepted': true,
      'driverId': currentUser.auth.currentUser!.uid,
      'driverName': currentUser.loggedUser.username,
      'arrivalTime': time,
      'driverPic': currentUser.loggedUser.carplatenum
    }).then((value) {
      requests = [];
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>),);
      notifyListeners();
    });
  }
}
