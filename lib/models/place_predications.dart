import 'package:flutter/cupertino.dart';

class Prediction {
  String? id;
  String? mainText;
  String? subtitle;

  Prediction(
      {required this.id, required this.mainText, required this.subtitle});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      id: json['place_id'],
      mainText: json['structured_formatting']['main_text'],
      subtitle: json['structured_formatting']['secondary_text'],
    );
  }
}
