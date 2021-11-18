import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? firstName;
  String? phoneNUmber;
  String? username;
  bool? isOnline;
  bool? isDriver;

  String? lastName;
  String? email;
  String? token;
  String? photo;

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
      this.isDriver,
      this.isOnline,
      this.lastName,
      this.licenceNo,
      this.carplatenum,
      this.phoneNUmber,
      this.photo,
      this.rating,
      this.token,
      this.trips,
      this.votes});

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    return UserModel(
      id: doc['id'],
      firstName: doc['firstname'],
      lastName: doc['lastname'],
      email: doc['email'],
      phoneNUmber: doc['phone'],
      trips: doc['trips'],
      photo: doc['photourl'],
      idNo: doc['id_num'],
      isDriver: doc['is_river'],
      isOnline: doc['is_online'],
      carplatenum: doc['car_plate_num'],
      rating: doc['rating'],
      token: doc['token'],
      votes: doc['votes'],
    );
  }

//   get id => _id;

//   set id(value) => _id = value;

//   get firstName => _firstName;

//   set firstName(value) => _firstName = value;

//   get phoneNUmber => _phoneNUmber;

//   set phoneNUmber(value) => _phoneNUmber = value;

//   get isOnline => _isOnline;

//   set isOnline(value) => _isOnline = value;

//   get isDriver => _isDriver;

//   set isDriver(value) => _isDriver = value;

//   get lastName => _lastName;

//   set lastName(value) => _lastName = value;

//   get email => _email;

//   set email(value) => _email = value;

//   get token => _token;

//   set token(value) => _token = value;

//   get photo => _photo;

//   set photo(value) => _photo = value;

//   get licenceNo => _licenceNo;

//   set licenceNo(value) => _licenceNo = value;

//   get idNo => _idNo;

//   set idNo(value) => _idNo = value;

//   get votes => _votes;

//   set votes(value) => _votes = value;

//   get trips => _trips;

//   set trips(value) => _trips = value;

//   get rating => _rating;

//   set rating(value) => _rating = value;
// }
}
