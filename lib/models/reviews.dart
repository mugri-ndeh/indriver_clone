import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  double? rating;
  String? review;
  String? userId;
  String? driverId;
  String? userName;

  Review({this.rating, this.review, this.userId, this.driverId, this.userName});

  factory Review.fromDocument(DocumentSnapshot doc) {
    return Review(
      rating: doc['rating'],
      review: doc['review'],
      userId: doc['userId'],
      driverId: doc['driverId'],
      userName: doc['userName'],
    );
  }
}
