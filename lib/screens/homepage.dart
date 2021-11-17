import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indriver_clone/providers/handle.dart';
import 'package:indriver_clone/screens/search_screen.dart';
import 'package:indriver_clone/ui/app_bar.dart';
import 'package:indriver_clone/ui/button.dart';
import 'package:indriver_clone/ui/constants.dart';
import 'package:indriver_clone/ui/nav_drawer.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:indriver_clone/util/assistant_methods.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    var provider = Provider.of<AppHandler>(context, listen: false);
    provider.mapController = controller;
    provider.locatePosition(context);
  }

  GoogleMapController? newController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const NavDrawer(),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<AppHandler>(
              builder: (_, location, __) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: GoogleMap(
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
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SingleChildScrollView(
                    child: Consumer<AppHandler>(
                      builder: (_, location, __) => Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showBottom(context, size, true);
                            },
                            child: ListTile(
                              leading: Icon(
                                Icons.circle_outlined,
                                color: location.startSelected
                                    ? startMarker
                                    : notSelected,
                              ),
                              // title: TextFormField(
                              //   enabled: false,
                              //   focusNode: FocusNode(canRequestFocus: true),
                              //   initialValue: 'wow',
                              //   decoration: const InputDecoration(
                              //       hintText: 'Pickup location'),
                              // ),
                              title: Text(location.startpoint),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //location.findPlace('');
                              showBottom(context, size, false);
                            },
                            child: ListTile(
                              leading: Icon(
                                Icons.circle_outlined,
                                color: location.endSelected
                                    ? endMarker
                                    : notSelected,
                              ),
                              // title: TextFormField(
                              //   focusNode: FocusNode(canRequestFocus: true),
                              //   //enabled: false,
                              //   // initialValue: location.destinationLocation ==
                              //   //         null
                              //   //     ? ''
                              //   //     : location.destinationLocation!.placeName,
                              //   initialValue: location.dummy,
                              //   decoration: const InputDecoration(
                              //       hintText: 'Destination'),
                              // ),
                              title: Stack(children: [
                                Text(location.endpoint),
                                const Positioned(
                                  child: Divider(
                                    thickness: 5,
                                  ),
                                  top: 10,
                                )
                              ]),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.money_sharp),
                            title: TextFormField(
                              decoration: const InputDecoration(
                                  hintText: 'Offer your fare'),
                            ),
                          ),
                          ListTile(
                              leading: const Icon(Icons.message),
                              title: TextFormField(
                                decoration: const InputDecoration(
                                    hintText: 'Comment and wishes'),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            BotButton(
                onTap: () {
                  makeRequest();
                },
                title: 'Request a vehicle')
          ],
        ),
      ),
    );
  }

  showBottom(BuildContext context, Size size, bool pickup) {
    showModalBottomSheet(
      elevation: 1,
      context: context,
      builder: (context) => SearchScreen(pickup: pickup),
    );
  }

  void makeRequest() {}
}
