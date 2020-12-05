import 'package:flutter/cupertino.dart';

class Payment {
  String paymentID;
  String clientID;
  String client;
  double amount;
  int date;

  Payment(
      {@required this.paymentID,
      @required this.clientID,
      @required this.client,
      @required this.amount,
      @required this.date});

  Payment.fromMap(Map<String, dynamic> map) {
    paymentID = map['paymentID'];
    clientID = map['clientID'];
    client = map['client'];
    amount = map['amount'];
    date = map['date'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map;
    map['paymentID'] = paymentID;
    map['clientID'] = clientID;
    map['client'] = client;
    map['amount'] = amount;
    map['date'] = date;

    return map;
  }
}
