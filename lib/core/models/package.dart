import 'package:flutter/material.dart';

class Package {
  String packageID;
  String title;
  double price;
  String description;
  int noSessions;
  Image image;
  int expiryDate;
  int datePurchased;

  Package(
      {@required this.packageID,
      @required this.title,
      @required this.price,
      @required this.description,
      @required this.noSessions,
      @required this.image,
      @required this.expiryDate,
      this.datePurchased = 0});

  Package.fromMap(Map<String, dynamic> map) {
    packageID = map['packageID'];
    title = map['title'];
    price = map['price'];
    description = map['description'];
    noSessions = map['noSessions'];
    image = map['image'];
    expiryDate = map['expiryDate'];
    datePurchased = map['datePurchased'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map;

    map['packageID'] = packageID;
    map['title'] = title;
    map['price'] = price;
    map['description'] = description;
    map['noSessions'] = noSessions;
    map['image'] = image;
    map['expiryDate'] = expiryDate;
    map['datePurchased'] = datePurchased;

    return map;
  }
}
