import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indriver_clone/models/address.dart';
import 'package:indriver_clone/models/direction_details.dart';
import 'package:indriver_clone/models/place_predications.dart';
import 'package:indriver_clone/providers/handle.dart';
import 'package:indriver_clone/util/config.dart';
import 'package:indriver_clone/util/request_assist.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAdress(
      Position position, context) async {
    String placeAdress = '';
    String url1 =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=AIzaSyBmnVJzMnmIJq0oRk4BiOpr_hVZm3fIOBE";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Config.api_key}";

    var response = await RequestAssistant.getRequest(url);

    print(url);

    if (response != 'failed') {
      placeAdress = response['results'][0]['formatted_address'];
      Address address = Address(
          latitude: position.latitude,
          longitude: position.longitude,
          placeName: placeAdress);
      Provider.of<AppHandler>(context, listen: false)
          .updatePickupLocationAdress(address);
    }
    return placeAdress;
  }

  static findPlace(String placename) async {
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

        var placeList =
            (predictions as List).map((e) => Prediction.fromJson(e)).toList();
      }
    }
  }

  static Future<DirectionDetails?> getDirectiondetials(
      LatLng startPoint, LatLng endPoint, BuildContext context) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startPoint.latitude},${startPoint.longitude}&destination=${endPoint.latitude},${endPoint.longitude}&key=${Config.api_key}";

    try {
      var result = await RequestAssistant.getRequest(url);

      if (result == 'failed') {
        return null;
      }

      DirectionDetails directionDetails = DirectionDetails(
        encodedPoints: result['routes'][0]['overview_polyline']['points'],
        distanceText: result['routes'][0]['legs'][0]['distance']['text'],
        distance: result['routes'][0]['legs'][0]['distance']['value'],
        durationText: result['routes'][0]['legs'][0]['distance']['text'],
        duration: result['routes'][0]['legs'][0]['duration']['value'],
      );
      return directionDetails;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text('Could not get directions'),
        ),
      );
      return null;
    }
  }

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
    pLineCoordinates.clear();

    if (decodedPoints.isNotEmpty) {
      for (var pointLatLng in decodedPoints) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    //clear nefore drawing directions
    polylineSet.clear();

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

    markersSet.add(startMarker);

    markersSet.add(endMarker);

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

    circlesSet.add(endCircle);
  }
}
