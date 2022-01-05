import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:indriver_clone/models/requests.dart';
import 'package:indriver_clone/models/user.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:indriver_clone/providers/handle.dart';
import 'package:indriver_clone/screens/homepage.dart';
import 'package:indriver_clone/screens/userprogressmap.dart';
import 'package:indriver_clone/ui/button.dart';
import 'package:provider/provider.dart';

class SendingRequests extends StatefulWidget {
  const SendingRequests({Key? key}) : super(key: key);

  @override
  _SendingRequestsState createState() => _SendingRequestsState();
}

class _SendingRequestsState extends State<SendingRequests> {
  var request;

  UserModel? user;

  @override
  void initState() {
    super.initState();
    request = getRequests();
    user = Provider.of<Authentication>(context, listen: false).loggedUser;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var loc = Provider.of<AppHandler>(context, listen: false);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          // loc.removeRequest();
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const HomePage(),
          //     ),
          //     (route) => false);
          return false;
        },
        child: StreamBuilder<QuerySnapshot>(
          stream: request,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  (route) => false);
            }
            if (snapshot.hasError) {
              return const Text('Something went wrong.');
            }

            if (snapshot.data!.docs.isEmpty) {
              Navigator.pop(context);
            }
            if (snapshot.data != null) {
              print('getting data');
              var request = snapshot.data!.docs.first;
              if (request['arrivalTime'].isNotEmpty) {
                var requestMod =
                    RideRequest.fromDocument(snapshot.data!.docs.first);
                if (request['answered'] == true &&
                    request['accepted'] == true) {
                  if (request['driverArrived'] == true) {
                    if (request['journeyStarted']) {
                      return Center(
                        child: BotButton(
                          onTap: () {
                            var user = Provider.of<Authentication>(context,
                                    listen: false)
                                .loggedUser;

                            leaveReview(context, request['driverId'],
                                user.username!, user.id!, requestMod.price!);
                          },
                          title: 'Finish Journney',
                        ),
                      );
                    }
                    return Center(
                      child: BotButton(
                        onTap: () {
                          startJourney(context);
                        },
                        title: 'Start Journey',
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('Waiting for driver to arrive'),
                    );
                  }
                } else {
                  return Center(
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(requestMod.driverPic!),
                          Text(request['driverName'] +
                              'will arrive in ' +
                              request['arrivalTime'] +
                              'minutes'),
                          BotButton(
                              onTap: () {
                                acceptRequest(context);
                              },
                              title: 'Accept'),
                          BotButton(
                              onTap: () {
                                declineRequest(context);
                              },
                              title: 'Decline')
                        ],
                      ),
                    ),
                  );
                }
              }
              if (request['driverId'] == "") {
                return Center(
                  child: SizedBox(
                    height: 200,
                    width: size.width * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                        const Text('Requesting driver Please wait'),
                        BotButton(
                          onTap: () {
                            loc.removeRequest();
                          },
                          title: 'cancel',
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(request['driverName'] + request['arrivalTime']),
                        BotButton(
                            onTap: () {
                              acceptRequest(context);
                            },
                            title: 'Accept'),
                        BotButton(
                            onTap: () {
                              declineRequest(context);
                            },
                            title: 'Decline')
                      ],
                    ),
                  ),
                );
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Stream<QuerySnapshot>? getRequests() {
    var provider = Provider.of<Authentication>(context, listen: false);
    try {
      return FirebaseFirestore.instance
          .collection('request')
          // .where('accepted', isEqualTo: false)
          .where('id', isEqualTo: provider.auth.currentUser!.uid)
          .snapshots();
    } catch (e) {
      return null;
    }
    //print(requests[0].username);
  }

//accept request from driver
  void acceptRequest(context) async {
    var currentUser =
        Provider.of<Authentication>(context, listen: false).auth.currentUser;
    await FirebaseFirestore.instance
        .collection('request')
        .doc(currentUser!.uid)
        .update({
      'accepted': true,
      'answered': true,
    }).then((value) {
      print('Waiting for Driver');
    });
  }

//reject request from driver
  void declineRequest(context) async {
    var currentUser =
        Provider.of<Authentication>(context, listen: false).auth.currentUser;
    await FirebaseFirestore.instance
        .collection('request')
        .doc(currentUser!.uid)
        .update({'accepted': false, 'driverId': "", 'answered': false}).then(
            (value) {
      print('Waiting for Driver');
    });
  }

//start journey
  void startJourney(context) async {
    var currentUser =
        Provider.of<Authentication>(context, listen: false).auth.currentUser;
    await FirebaseFirestore.instance
        .collection('request')
        .doc(currentUser!.uid)
        .update({'journeyStarted': true}).then((value) {
      print('journey has started');
    });
  }

//end ourney
  void endJourney(context, String id, String amount) async {
    var currentUser =
        Provider.of<Authentication>(context, listen: false).auth.currentUser;
    var loc = Provider.of<AppHandler>(context, listen: false);
    //add trip

//set earning to driver after journey is completed
    await FirebaseFirestore.instance.collection('earnings').add({
      'driverId': id,
      'amount': amount,
      'date': DateTime.now(),
    }).then((value) async {
      // remove request online
      loc.removeRequest();
    });
  }

//leave review after journey is completed

  var reviewControlller = TextEditingController();
  void leaveReview(BuildContext context, String id, String username,
      String userID, String price) {
    double ratingInit = 3.0;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 200,
                      child: TextFormField(
                        controller: reviewControlller,
                        decoration:
                            const InputDecoration(hintText: 'Write a review'),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Center(
                    child: Container(
                      height: 100,
                      child: RatingBar.builder(
                        initialRating: ratingInit,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        onRatingUpdate: (rating) {
                          ratingInit = rating;

                          print(rating);
                        },
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  BotButton(
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(id)
                            .update({
                          'trips': FieldValue.increment(1),
                          'rating': FieldValue.increment(ratingInit),
                          'earnings': FieldValue.increment(double.parse(price))
                        });
                        addreview(id, username, userID,
                            reviewControlller.text.trim(), ratingInit);
                        endJourney(context, id, price);
                        Navigator.pop(context);
                      },
                      title: 'Submit Review')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//add review function
  void addreview(String driverId, String username, String userId, String review,
      double rating) async {
    Map<String, dynamic> reviews = {
      'driverId': driverId,
      'userName': username,
      'userId': userId,
      'review': review,
      'rating': rating
    };
    await FirebaseFirestore.instance.collection('reviews').add(reviews);
  }
}
