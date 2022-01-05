import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:indriver_clone/driver/screens/main_page.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:indriver_clone/providers/handle.dart';
import 'package:indriver_clone/screens/homepage.dart';
import 'package:indriver_clone/ui/button.dart';
import 'package:provider/provider.dart';

class Waiting extends StatefulWidget {
  Waiting({Key? key}) : super(key: key);

  @override
  _WaitingState createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  var requests;
  getRequest() {
    var provider = Provider.of<Authentication>(context, listen: false);
    return FirebaseFirestore.instance
        .collection('request')
        .where('driverId', isEqualTo: provider.auth.currentUser!.uid)
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    requests = getRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot?>(
          stream: requests,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // if (snapshot.data!.docs.first['driverArrived'] == true) {
            //   return const Center(
            //     child: Text('Journey has ended'),
            //   );
            // }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                  child: BotButton(
                onTap: () {
                  Navigator.pop(context);
                },
                title: 'Go back',
              ));
            }
            if (snapshot.data!.docs.first['answered'] == true &&
                snapshot.data!.docs.first['accepted'] == false) {
              return Center(
                child: BotButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: 'Go back'),
              );
            }

            if (snapshot.data!.docs.first['answered'] == true) {
              if (snapshot.data!.docs.first['accepted'] == true &&
                  snapshot.data!.docs.first['driverArrived'] == false) {
                return Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Heading to passenger location'),
                        Center(
                          child: BotButton(
                              onTap: () {
                                driverArrivedLocation(
                                    snapshot.data!.docs.first['id']);
                              },
                              title: "I've arrived"),
                        )
                      ],
                    ),
                  ),
                );
              } else if (snapshot.data!.docs.first['accepted'] == true &&
                  snapshot.data!.docs.first['driverArrived'] == true) {
                if (snapshot.data!.docs.first['journeyStarted'] == true) {
                  return const Center(
                    child: Text('Journey Ongoing'),
                  );
                } else if (snapshot.data!.docs.first['journeyStarted'] ==
                    false) {
                  return const Center(
                    child: Text('Tell passenger to start journey on his phone'),
                  );
                }
              }

              return const Center(
                child: Text('Waiting For user Response'),
              );
            } else {
              return const Center(
                child: Text('Waiting For user Response'),
              );
            }
          }),
    );
  }

  void driverArrivedLocation(String id) {
    var user =
        Provider.of<Authentication>(context, listen: false).auth.currentUser;
    print(user!.uid);

    FirebaseFirestore.instance.collection('request').doc(id).update({
      'driverArrived': true,
    });
  }
}
