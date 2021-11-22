import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:indriver_clone/driver/screens/earnings.dart';

class Earnings {
  String? amount;
  String? date;
  String? rating;

  Earnings({
    this.amount,
    this.date,
    this.rating,
  });

  factory Earnings.fromDocument(DocumentSnapshot doc) {
    return Earnings(
      amount: doc['amount'],
      date: doc['date'],
      rating: doc['rating'],
    );
  }
}
