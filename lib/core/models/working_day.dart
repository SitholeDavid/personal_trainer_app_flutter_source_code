import 'package:flutter/material.dart';

class WorkingDay {
  String title;
  DateTime startTime = DateTime(2020, 0, 0, 5, 30);
  DateTime endTime = DateTime(2020, 0, 0, 17, 0);
  DateTime duration = DateTime(2020, 0, 0, 0, 45);
  int key;

  WorkingDay(
      {this.title, this.startTime, this.endTime, this.duration, this.key}) {
    startTime = startTime ?? DateTime(2020, 0, 0, 5, 30);
    endTime = endTime ?? DateTime(2020, 0, 0, 17, 0);
    duration = duration ?? DateTime(2020, 0, 0, 0, 45);
  }

  WorkingDay.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    startTime = map['startTime'];
    endTime = map['endTime'];
    duration = map['duration'];
    key = map['key'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map;

    map['title'] = title;
    map['startTime'] = startTime.toString();
    map['endTime'] = endTime.toString();
    map['duration'] = duration.toString();
    map['key'] = key;

    return map;
  }
}
