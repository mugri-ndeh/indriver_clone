import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:indriver_clone/models/reviews.dart';
import 'package:indriver_clone/models/user.dart';
import 'package:indriver_clone/providers/auth.dart';
import 'package:indriver_clone/ui/constants.dart';
import 'package:provider/provider.dart';

class Ratings extends StatefulWidget {
  Ratings({Key? key}) : super(key: key);

  @override
  _RatingsState createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> with AutomaticKeepAliveClientMixin {
  var review;
  UserModel? user;

  Stream<QuerySnapshot> getReviews() {
    var id = Provider.of<Authentication>(context, listen: false).loggedUser.id;
    print('what');
    return FirebaseFirestore.instance
        .collection('reviews')
        .where('driverId', isEqualTo: id)
        .snapshots();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    review = getReviews();
    user = Provider.of<Authentication>(context, listen: false).loggedUser;
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Column(
      //       children: [
      //         Center(
      //           child: Container(
      //             height: 200,
      //             width: size.width * 0.95,
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(16),
      //               color: primaryColor,
      //             ),
      //           ),
      //         ),
      //         const Padding(
      //           padding: EdgeInsets.all(5),
      //         ),
      //         Center(
      //           child: Container(
      //             height: 100,
      //             width: size.width * 0.95,
      //             decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(16),
      //                 color: primaryColor),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: StreamBuilder<QuerySnapshot>(
          stream: review,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.data != null) {
              var reviews = snapshot.data!.docs
                  .map((e) => Review.fromDocument(e))
                  .toList();
              user = Provider.of<Authentication>(context, listen: false)
                  .loggedUser;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Overall Rating: ' +
                        (user!.rating! / (1 + user!.trips!).toInt())
                            .toDouble()
                            .ceilToDouble()
                            .toString()),
                  ),
                  Container(),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: reviews.length,
                    itemBuilder: (context, index) => Container(
                      decoration:
                          BoxDecoration(color: Colors.white24, boxShadow: [
                        BoxShadow(
                            offset: const Offset(1, 0),
                            color: primaryColor.withOpacity(0.1),
                            blurRadius: 1)
                      ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: ListTile(
                          title: Text('Review by: ' + reviews[index].userName!),
                          trailing: Text(reviews[index].review ?? ''),
                          subtitle: Text(
                              'Rating: ' + reviews[index].rating.toString()),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text('No Reviews Yet'));
          }),
    );
  }
}
