import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:indriver_clone/models/reviews.dart';

class Services with ChangeNotifier {
  void startRide(String id) async {
    await FirebaseFirestore.instance.collection('request').doc(id).update({});
  }

  void endRide(String id) async {
    await FirebaseFirestore.instance.collection('request').doc(id).update({});
    await FirebaseFirestore.instance.collection('request').doc(id).delete();
    notifyListeners();
  }

  void leaveReview(Review review) async {
    await FirebaseFirestore.instance
        .collection('request')
        .doc(review.driverId)
        .update({});
  }
}
