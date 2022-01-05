import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:indriver_clone/providers/handle.dart';
import 'package:indriver_clone/util/assistant_methods.dart';
import 'package:provider/provider.dart';

class UserProgressMap extends StatefulWidget {
  const UserProgressMap({Key? key}) : super(key: key);

  @override
  State<UserProgressMap> createState() => _UserProgressMapState();
}

class _UserProgressMapState extends State<UserProgressMap> {
  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) async {
    var provider = Provider.of<AppHandler>(context, listen: false);
    var prov = Provider.of<Authentication>(context, listen: false);
    provider.mapController = controller;
    provider.locatePosition(context);

    await AssistantMethods().getDirection(
        context,
        provider.requests.first.startLat!,
        provider.requests.first.startLong!,
        provider.requests.first.endLat!,
        provider.requests.first.endLong!,
        controller);
    print(provider.requests.first.startLat);
  }

  GoogleMapController? newController;

  _mapTapped(LatLng location) {
    print(location);
// The result will be the location you've been selected
// something like this LatLng(12.12323,34.12312)
// you can do whatever you do with it
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var location = Provider.of<AppHandler>(context, listen: false);
    return Scaffold(
      body: Container(
        child: GoogleMap(
          onTap: _mapTapped,
          mapType: MapType.normal,
          myLocationEnabled: true,
          markers: location.markersSet,
          circles: location.circlesSet,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 14.0,
          ),
          myLocationButtonEnabled: true,
          //zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          polylines: location.polylineSet,
        ),
      ),
    );
  }
}
