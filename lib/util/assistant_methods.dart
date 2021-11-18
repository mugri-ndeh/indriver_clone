import 'package:flutter/material.dart';
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
}
