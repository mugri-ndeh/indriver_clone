import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:indriver_clone/admin/screens/monitor_drivers.dart';
import 'package:indriver_clone/admin/screens/verify_screen.dart';
import 'package:indriver_clone/admin/ui/nav.dart';
import 'package:indriver_clone/admin/util/data.dart';
import 'package:indriver_clone/models/user.dart';
import 'package:indriver_clone/ui/button.dart';
import 'package:indriver_clone/ui/constants.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  var start;
  Stream<QuerySnapshot?> allUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('submittedStatus', isEqualTo: 'waiting')
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    start = allUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: DashboardNav()),
      body: StreamBuilder<QuerySnapshot?>(
        stream: start,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No unverified Users'),
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
                                builder: (context) => VerifyDriver(
                                  user: userList[index],
                                ),
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
