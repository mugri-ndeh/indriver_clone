import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indriver_clone/models/address.dart';
import 'package:indriver_clone/models/place_predications.dart';
import 'package:indriver_clone/util/assistant_methods.dart';
import 'package:indriver_clone/util/config.dart';
import 'package:indriver_clone/util/request_assist.dart';

class AppHandler with ChangeNotifier {
  void init(context) {
    locatePosition(context);
    notifyListeners();
  }

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
          InfoWindow(title: initialPosition.placeName, snippet: 'Destination'),
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
}
