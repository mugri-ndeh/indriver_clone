import 'package:cloud_firestore/cloud_firestore.dart';

class Earnings {
  String? amount;
  String? date;
  String? driverId;

  Earnings({
    this.amount,
    this.date,
    this.driverId,
  });

  factory Earnings.fromDocument(DocumentSnapshot doc) {
    return Earnings(
      amount: doc['amount'],
      date: doc['date'],
      driverId: doc['driverId'],
    );
  }
}
