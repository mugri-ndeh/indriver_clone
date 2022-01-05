import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indriver_clone/driver/screens/main_page.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:indriver_clone/providers/handle.dart';
import 'package:indriver_clone/screens/account_details.dart';
import 'package:indriver_clone/screens/search_screen.dart';
import 'package:indriver_clone/screens/send_requests.dart';
import 'package:indriver_clone/screens/userprogressmap.dart';
import 'package:indriver_clone/ui/app_bar.dart';
import 'package:indriver_clone/ui/button.dart';
import 'package:indriver_clone/ui/constants.dart';
import 'package:indriver_clone/ui/nav_drawer.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:indriver_clone/util/assistant_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LatLng _center = const LatLng(45.521563, -122.677433);
  var request;

  void _onMapCreated(GoogleMapController controller) {
    var provider = Provider.of<AppHandler>(context, listen: false);
    var prov = Provider.of<Authentication>(context, listen: false);
    provider.mapController = controller;
    provider.locatePosition(context);
  }

  GoogleMapController? newController;

  _mapTapped(LatLng location) {
    print(location);
  }

  final _moneyController = TextEditingController();
  final _wishesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = userId();
  }

  Stream<QuerySnapshot> userId() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var auth = Provider.of<Authentication>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
        stream: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return const CompleteSignUp();
          } else {
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
                            zoomControlsEnabled: true,
                            zoomGesturesEnabled: true,
                            polylines: location.polylineSet,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Form(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Form(
                              key: _formKey,
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
                                          controller: _moneyController,
                                          validator: (val) => val!.isEmpty
                                              ? 'Please enter your price'
                                              : null,
                                          decoration: const InputDecoration(
                                              hintText: 'Offer your fare, KES'),
                                        ),
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.message),
                                        title: TextFormField(
                                          controller: _wishesController,
                                          decoration: const InputDecoration(
                                              hintText: 'Comment and wishes'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Consumer<AppHandler>(
                        builder: (_, loc, __) => BotButton(
                            onTap: () {
                              print(loc.endpoint);
                              if (loc.endpoint != 'End point') {
                                if (_formKey.currentState!.validate()) {
                                  loc.sendRequest(
                                      loc.pickupLocation!.latitude!.toString(),
                                      loc.pickupLocation!.longitude!.toString(),
                                      false,
                                      auth.loggedUser.username!,
                                      DateTime.now().toString(),
                                      '672617465',
                                      loc.pickupLocation!.placeName!,
                                      loc.destinationLocation!.placeName!,
                                      loc.destinationLocation!.latitude!
                                          .toString(),
                                      loc.destinationLocation!.longitude!
                                          .toString(),
                                      _moneyController.text);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SendingRequests(),
                                    ),
                                  );
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: SizedBox(
                                      height: 150,
                                      width: size.width * 0.6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                              'Please select a drop off location'),
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
                            },
                            title: 'Request a vehicle'),
                      )
                    ],
                  ),
                ));
          }
        });
  }

  showBottom(BuildContext context, Size size, bool pickup) {
    showModalBottomSheet(
      elevation: 1,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) => SearchScreen(pickup: pickup),
    );
  }
}
