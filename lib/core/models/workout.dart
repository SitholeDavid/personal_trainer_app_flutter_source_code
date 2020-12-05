import 'package:flutter/cupertino.dart';

class Workout {
  String workoutID;
  String title;
  String description;

  Workout(
      {@required this.workoutID,
      @required this.title,
      @required this.description});

  Workout.fromMap(Map<String, dynamic> map) {
    workoutID = map['workoutID'];
    title = map['title'];
    description = map['description'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map;
    map['workoutID'] = workoutID;
    map['title'] = title;
    map['description'] = description;

    return map;
  }
}
