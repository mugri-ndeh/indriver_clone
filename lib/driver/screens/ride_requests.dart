import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:indriver_clone/driver/screens/drivermap.dart';
import 'package:indriver_clone/models/requests.dart';
import 'package:indriver_clone/providers/handle.dart';
import 'package:provider/provider.dart';

class RideRequests extends StatefulWidget {
  const RideRequests({Key? key}) : super(key: key);

  @override
  _RideRequestsState createState() => _RideRequestsState();
}

class _RideRequestsState extends State<RideRequests>
    with AutomaticKeepAliveClientMixin {
  var requests;
  getRequest() {
    var provider = Provider.of<AppHandler>(context, listen: false);
    return FirebaseFirestore.instance
        .collection('request')
        .where('accepted', isEqualTo: false)
        .snapshots();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requests = getRequest();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppHandler>(context, listen: false);
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: requests,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No available requests'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  provider.requests = snapshot.data!.docs
                      .map((e) => RideRequest.fromDocument(e))
                      .toList();
                  return ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('New Request'),
                        Text('From: ' +
                            snapshot.data!.docs[index]['startAddress']),
                        Text('To: ' + snapshot.data!.docs[index]['endAddress']),
                      ],
                    ),
                    subtitle: Text('Amount offered: ' +
                        provider.requests[index].price! +
                        'KES'),
                    trailing: ElevatedButton(
                      child: const Text('See details'),
                      onPressed: () async {
                        //provider.acceptRequest(index, context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DriverMap(request: provider.requests[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
