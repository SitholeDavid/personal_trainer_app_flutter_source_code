import 'package:flutter/cupertino.dart';

class Trainer {
  String id;
  String email;
  String name;
  String bankingDetails;
  String phoneNumber;

  Trainer(
      {@required this.id,
      @required this.email,
      this.name = '',
      this.bankingDetails = '',
      this.phoneNumber = ''});

  Trainer.fromMap(Map<String, dynamic> map, String uid) {
    id = uid;
    email = map['email'];
    name = map['name'];
    bankingDetails = map['bankingDetails'];
    phoneNumber = map['phoneNumber'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'name': name,
        'bankingDetails': bankingDetails ?? '',
        'phoneNumber': phoneNumber ?? ''
      };

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map;

    map['email'] = email;
    map['name'] = name;
    map['bankingDetails'] = bankingDetails;
    map['phoneNumber'] = phoneNumber;

    return map;
  }
}
