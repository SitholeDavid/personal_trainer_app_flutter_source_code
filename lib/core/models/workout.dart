import 'package:flutter/cupertino.dart';

class Workout {
  int workoutID;
  String title;
  String description;

  Workout({this.workoutID, @required this.title, @required this.description});

  Workout.fromMap(Map<String, dynamic> map) {
    workoutID = map['id'];
    title = map['title'];
    description = map[
        'summary']; //SQLITE does not accept 'description' as column name, rename to summary for storage
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map;
    map['title'] = title;
    map['summary'] =
        description; //SQLITE does not accept 'description' as column name, rename to summary for storage

    return map;
  }

  Map<String, dynamic> toJson() => {'title': title, 'summary': description};
}
