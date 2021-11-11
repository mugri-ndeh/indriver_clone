import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indriver_clone/ui/app_bar.dart';
import 'package:indriver_clone/ui/nav_drawer.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    locatePosition();
  }

  Position? liveLocation;
  var geolocator = Geolocator();

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    liveLocation = position;

    LatLng liveposition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: liveposition, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  GoogleMapController? newController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 14.0,
                ),
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: const [
                      ListTile(
                          leading: Icon(Icons.circle_outlined),
                          title: TextField(
                            decoration:
                                InputDecoration(hintText: 'Pickup location'),
                          )),
                      ListTile(
                          leading: Icon(Icons.circle_outlined),
                          title: TextField(
                            decoration:
                                InputDecoration(hintText: 'Destination'),
                          )),
                      ListTile(
                        leading: Icon(Icons.money_sharp),
                        title: TextField(
                          decoration:
                              InputDecoration(hintText: 'Offer your fare'),
                        ),
                      ),
                      ListTile(
                          leading: Icon(Icons.message),
                          title: TextField(
                            decoration:
                                InputDecoration(hintText: 'Comment and wishes'),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {}, child: const Text('Request a vehicle'))
          ],
        ),
      ),
    );
  }
}
