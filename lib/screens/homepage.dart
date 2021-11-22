import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:indriver_clone/providers/handle.dart';
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
    print('Currency');
    currency();
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
    request = getRequests();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var auth = Provider.of<Authentication>(context, listen: false);
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
            Consumer<AppHandler>(
              builder: (_, loc, __) => BotButton(
                  onTap: () {
                    print(loc.endpoint);
                    if (loc.endpoint != 'End point') {
                      loc.sendRequest(
                          loc.pickupLocation!.latitude!.toString(),
                          loc.pickupLocation!.longitude!.toString(),
                          false,
                          auth.loggedUser.username!,
                          DateTime.now().toString(),
                          '672617465',
                          loc.pickupLocation!.placeName!,
                          loc.destinationLocation!.placeName!,
                          loc.destinationLocation!.latitude!.toString(),
                          loc.destinationLocation!.longitude!.toString(),
                          '500');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SendingRequests(),
                        ),
                      );
                    } else {
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
                  },
                  title: 'Request a vehicle'),
            )
          ],
        ),
      ),
    );
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

  void currency() {
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());
    print("CURRENCY SYMBOL ${format.currencySymbol}"); // $
    print("CURRENCY NAME ${format.currencyName}"); // USD
  }

  Future<bool> _cancelRequest() async {
    //loc.removeRequest();
    return true;
  }

  Stream<QuerySnapshot>? getRequests() {
    var provider = Provider.of<Authentication>(context, listen: false);
    try {
      return FirebaseFirestore.instance
          .collection('request')
          .where('accepted', isEqualTo: false)
          .where('id', isEqualTo: provider.auth.currentUser!.uid)
          .snapshots();
    } catch (e) {
      return null;
    }
    //print(requests[0].username);
  }

  void acceptRequest(context) async {
    var currentUser =
        Provider.of<Authentication>(context, listen: false).auth.currentUser;
    await FirebaseFirestore.instance
        .collection('request')
        .doc(currentUser!.uid)
        .update({
      'accepted': true,
    }).then((value) {
      print('Waiting for Driver');
    });
  }

  void declineRequest(context) async {
    var currentUser =
        Provider.of<Authentication>(context, listen: false).auth.currentUser;
    await FirebaseFirestore.instance
        .collection('request')
        .doc(currentUser!.uid)
        .update({
      'driverId': "",
    }).then((value) {
      print('Waiting for Driver');
    });
  }
}
