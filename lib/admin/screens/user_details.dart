import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:indriver_clone/models/earnings.dart';
import 'package:indriver_clone/models/user.dart';
import 'package:indriver_clone/ui/button.dart';

class MonitoringDriver extends StatefulWidget {
  const MonitoringDriver({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  MonitoringDriverState createState() => MonitoringDriverState();
}

class MonitoringDriverState extends State<MonitoringDriver> {
  var userDetail;
  final _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot> userDetails() {
    return _firestore.collection('users').doc(widget.user.id).snapshots();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('GOTOTO');
    userDetail = userDetails();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<DocumentSnapshot>(
                stream: userDetail,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.data == null) {
                    return const Center(
                      child: Text('Nothing to show here'),
                    );
                  }
                  var user = UserModel.fromSnapshot(snapshot.data!);
                  int? sum = 0;
                  print('');
                  print(user.email);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Image.network(widget.user.photo!),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.username!),
                                  Text(user.email!),
                                  Text(user.phoneNumber!),
                                  Text(user.firstName! + ' ' + user.lastName!)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('Total Earnings'),
                        subtitle: Text(user.earnings!.toString() + 'KES'),
                      ),
                      ListTile(
                        title: const Text('Number of trips'),
                        subtitle: Text(user.trips!.toString()),
                      ),
                      ListTile(
                        title: Text('Account Status'),
                        subtitle: Text(user.token!),
                      ),
                      ListTile(
                          title: const Text('Rating'),
                          subtitle: Text(
                              (user.rating! / (1 + user.trips!).toInt())
                                  .toDouble()
                                  .roundToDouble()
                                  .toString())),
                      BotButton(
                          onTap: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Account Blocked'),
                              ),
                            );

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.id)
                                .update({
                              'token': user.token == 'OK' ? 'suspended' : 'OK'
                            });

                            // Navigator.pop(context);
                          },
                          title: user.token == 'suspended'
                              ? 'Unsuspend Account'
                              : 'Suspend Account'),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
