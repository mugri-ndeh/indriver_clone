import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:provider/provider.dart';

class Earnings extends StatefulWidget {
  const Earnings({Key? key}) : super(key: key);

  @override
  _EarningsState createState() => _EarningsState();
}

class _EarningsState extends State<Earnings>
    with AutomaticKeepAliveClientMixin {
  var earnings;

  Stream<QuerySnapshot> getEarnings() {
    var id = Provider.of<Authentication>(context, listen: false).loggedUser.id;
    return FirebaseFirestore.instance
        .collection('earnings')
        .where('driverId', isEqualTo: id)
        .snapshots();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    earnings = getEarnings();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: earnings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    'Amount: ${snapshot.data!.docs[index]['amount']}KES',
                  ),
                  subtitle: Text(
                    'Date: ${snapshot.data!.docs[index]['date'].toDate()}',
                  ),
                ),
              );
            } else {
              return const Center(
                // ignore: prefer_const_constructors
                child: Text('No earings yet'),
              );
            }
          }),
    );
  }
}
