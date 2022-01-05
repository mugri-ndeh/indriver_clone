import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:indriver_clone/admin/screens/user_details.dart';
import 'package:indriver_clone/models/user.dart';
import 'package:indriver_clone/ui/constants.dart';

class MonitorDrivers extends StatefulWidget {
  MonitorDrivers({Key? key}) : super(key: key);

  @override
  _MonitorDriversState createState() => _MonitorDriversState();
}

class _MonitorDriversState extends State<MonitorDrivers>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  var data;
  Stream<QuerySnapshot?> allUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('driverAccount', isEqualTo: true)
        .snapshots();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = allUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot?>(
        stream: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No Drivers'),
            );
          } else {
            List<UserModel> userList = snapshot.data!.docs
                .map((e) => UserModel.fromSnapshot(e))
                .toList();
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) => Container(
                  height: 100,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 5,
                      color: primaryColor.withOpacity(0.2),
                    ),
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userList[index].username!),
                            Text(userList[index].phoneNumber!)
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MonitoringDriver(user: userList[index]),
                              ),
                            );
                          },
                          child: const Text('View Details'),
                        ),
                      ],
                    ),
                  )),
            );
          }
        },
      ),
    );
  }
}
