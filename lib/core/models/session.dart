import 'package:flutter/cupertino.dart';

class Session {
  String sessionID;
  String startTime;
  String client;

  Session(
      {@required this.sessionID,
      @required this.startTime,
      @required this.client});

  Session.fromMap(Map<String, dynamic> map, String uid) {
    sessionID = uid;
    startTime = map['startTime'];
    client = map['client'];
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'startTime': startTime, 'client': client};
}
