import 'package:flutter/cupertino.dart';

class Session {
  String sessionID;
  int epoch;
  String client;

  Session(
      {@required this.sessionID, @required this.epoch, @required this.client});

  Session.fromMap(Map<String, dynamic> map) {
    sessionID = map['sessionID'];
    epoch = map['epoch'];
    client = map['client'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map;
    map['sessionID'] = sessionID;
    map['epoch'] = epoch;
    map['client'] = client;

    return map;
  }
}
