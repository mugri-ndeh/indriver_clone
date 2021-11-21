import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideRequest {
  String? id;
  String? startLat;
  String? startLong;
  bool? accepted;
  String? username;
  String? timeCreated;
  String? phoneNum;
  String? startAddress;
  String? endAddress;
  String? endLat;
  String? endLong;
  String? price;
  String? driverId;
  bool? driverArrived;

  RideRequest(
      {this.id,
      this.accepted,
      this.startAddress,
      this.endAddress,
      this.startLat,
      this.endLat,
      this.startLong,
      this.endLong,
      this.phoneNum,
      this.timeCreated,
      this.price,
      this.username,
      this.driverId,
      this.driverArrived});

  factory RideRequest.fromDocument(DocumentSnapshot doc) {
    return RideRequest(
      id: doc['id'],
      startLat: doc['startLat'],
      endLat: doc['endLat'],
      startLong: doc['startLong'],
      endLong: doc['endLong'],
      startAddress: doc['startAddress'],
      endAddress: doc['endAddress'],
      username: doc['username'],
      accepted: doc['accepted'],
      phoneNum: doc['phoneNum'],
      timeCreated: doc['timeCreated'],
      price: doc['price'],
      driverId: doc['driverId'],
      driverArrived: doc['driverArrived'],
    );
  }
}
