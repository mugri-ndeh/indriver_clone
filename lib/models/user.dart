import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? firstName;
  String? phoneNumber;
  String? username;
  bool? isOnline;
  bool? isDriver;

  String? lastName;
  String? email;
  String? token;
  String? photo;
  String? dob;

  String? licenceNo;
  String? carplatenum;
  String? idNo;

  int? votes;
  int? trips;
  double? rating;

  UserModel(
      {this.id,
      this.firstName,
      this.username,
      this.email,
      this.idNo,
      this.dob,
      this.isDriver,
      this.isOnline,
      this.lastName,
      this.licenceNo,
      this.carplatenum,
      this.phoneNumber,
      this.photo,
      this.rating,
      this.token,
      this.trips,
      this.votes});

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    return UserModel(
        id: doc['id'],
        firstName: doc['firstName'],
        lastName: doc['lastName'],
        email: doc['email'],
        username: doc['username'],
        phoneNumber: doc['phoneNumber'],
        trips: doc['trips'],
        photo: doc['photo'],
        idNo: doc['idNo'],
        isDriver: doc['isDriver'],
        isOnline: doc['isOnline'],
        carplatenum: doc['carplatenum'],
        rating: doc['rating'],
        token: doc['token'],
        votes: doc['votes'],
        dob: doc['dob']);
  }
}
