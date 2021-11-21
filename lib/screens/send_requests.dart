import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:indriver_clone/providers/handle.dart';
import 'package:indriver_clone/ui/button.dart';
import 'package:provider/provider.dart';

class SendingRequests extends StatefulWidget {
  const SendingRequests({Key? key}) : super(key: key);

  @override
  _SendingRequestsState createState() => _SendingRequestsState();
}

class _SendingRequestsState extends State<SendingRequests> {
  var request;

  @override
  void initState() {
    super.initState();
    request = getRequests();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var loc = Provider.of<AppHandler>(context, listen: false);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          loc.removeRequest();
          return true;
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
                return const Center();
              }
              var request = snapshot.data!.docs.first;
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
                        ElevatedButton(
                          onPressed: () {
                            loc.removeRequest();
                            Navigator.pop(context);
                          },
                          child: const Text('cancel'),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  child: Center(
                    child: SizedBox(
                      child: Column(
                        children: [
                          Text(request['driverId']),
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
                  ),
                );
              }
            }),
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
      'accepted': false,
      'driverId': "",
    }).then((value) {
      print('Waiting for Driver');
    });
  }
}
