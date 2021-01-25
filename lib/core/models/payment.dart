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

  Payment.fromMap(Map<String, dynamic> map, String uid) {
    paymentID = uid;
    clientID = map['clientID'];
    client = map['client'];
    amount = map['amount'];
    date = map['date'];
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'paymentID': paymentID,
        'clientID': clientID,
        'client': client,
        'amount': amount,
        'date': date
      };
}
