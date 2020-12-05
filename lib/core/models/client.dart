import 'package:flutter/cupertino.dart';

class Client {
  String clientID;
  String name;
  String surname;
  String email;
  Image picture;
  List<double> weight;
  double height;
  String healthConditions;
  String phoneNo;

  Client(
      {this.clientID,
      this.name,
      this.surname,
      this.email,
      this.picture,
      this.weight,
      this.healthConditions,
      this.phoneNo});

  Client.fromMap(Map<String, dynamic> map) {
    clientID = map['clientID'];
    name = map['name'];
    surname = map['surname'];
    email = map['email'];
    picture = map['picture'];
    weight = map['weight'];
    healthConditions = map['healthConditions'];
    phoneNo = map['phoneNo'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map;
    map['clientID'] = clientID;
    map['name'] = name;
    map['surname'] = surname;
    map['email'] = email;
    map['picture'] = picture;
    map['weight'] = weight;
    map['healthConditions'] = healthConditions;
    map['phoneNo'] = phoneNo;

    return map;
  }
}
