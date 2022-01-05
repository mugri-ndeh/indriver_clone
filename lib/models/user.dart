import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? firstName;
  String? phoneNumber;
  String? username;
  bool? isOnline;
  bool? isDriver;
  bool? isAdmin;
  bool? driverAccount;
  bool? verified;

  String? lastName;
  String? email;
  String? token;
  String? photo;
  String? dob;

  String? licenceNo;
  String? carplatenum;
  String? idNo;
  String? submittedStatus;

  int? votes;
  int? trips;
  double? earnings;
  double? rating;

  UserModel({
    this.id,
    this.firstName,
    this.username,
    this.email,
    this.isAdmin,
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
    this.votes,
    this.driverAccount,
    this.submittedStatus,
    this.verified,
    this.earnings,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    return UserModel(
      id: doc['id'],
      firstName: doc['firstName'],
      lastName: doc['lastName'],
      email: doc['email'],
      username: doc['username'],
      phoneNumber: doc['phoneNumber'],
      trips: doc['trips'].toInt(),
      photo: doc['photo'],
      idNo: doc['idNo'],
      isDriver: doc['isDriver'],
      isOnline: doc['isOnline'],
      carplatenum: doc['carplatenum'],
      rating: doc['rating'].toDouble(),
      token: doc['token'],
      votes: doc['votes'].toInt(),
      dob: doc['dob'],
      licenceNo: doc['licenceNo'],
      isAdmin: doc['isAdmin'],
      driverAccount: doc['driverAccount'],
      verified: doc['verified'],
      submittedStatus: doc['submittedStatus'],
      earnings: doc['earnings'].toDouble(),
    );
  }
}
