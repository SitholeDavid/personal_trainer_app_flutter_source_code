import 'package:flutter/cupertino.dart';

import 'models/session.dart';

Map<String, dynamic> dialogCustomData(dynamic value,
        {TextInputType inputType = TextInputType.text}) =>
    {'value': value, 'inputType': inputType};

String getWeekday(int weekday) {
  switch (weekday) {
    case 1:
      return 'MON';
    case 2:
      return 'TUE';
    case 3:
      return 'WED';
    case 4:
      return 'THU';
    case 5:
      return 'FRI';
    case 6:
      return 'SAT';
    case 7:
      return 'SUN';
    default:
      return 'SUN';
  }
}

int getIntWeekday(String weekday) {
  switch (weekday) {
    case 'Monday':
      return 1;
    case 'Tuesday':
      return 2;
    case 'Wednesday':
      return 3;
    case 'Thursday':
      return 4;
    case 'Friday':
      return 5;
    case 'Saturday':
      return 6;
    case 'Sunday':
      return 7;
    default:
      return 1;
  }
}

String getFullWeekday(int weekday) {
  switch (weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return 'Sunday';
  }
}

String getMonth(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return 'January';
  }
}

List<Session> createSessions(
    String day, DateTime startTime, DateTime endTime, DateTime duration) {
  DateTime currentDay = DateTime.now();
  int weekday = getIntWeekday(day);

  DateTime selectedDay =
      currentDay.add(Duration(days: weekday - currentDay.weekday));

  DateTime nextSlot = DateTime.utc(selectedDay.year, selectedDay.month,
      selectedDay.day, startTime.hour, startTime.minute);

  DateTime endSlot = DateTime.utc(selectedDay.year, selectedDay.month,
      selectedDay.day, endTime.hour, endTime.minute);
  var sessions = <Session>[];

  while (nextSlot.isBefore(endSlot)) {
    var nextSession = Session(
        client: 'Available', sessionID: '', startTime: nextSlot.toString());

    sessions.add(nextSession);
    nextSlot =
        nextSlot.add(Duration(hours: duration.hour, minutes: duration.minute));
  }

  return sessions;
}

bool timeComesBefore(DateTime dateA, DateTime dateB) {
  if (dateA.hour < dateB.hour)
    return true;
  else if (dateA.hour == dateB.hour && dateA.minute < dateB.minute)
    return true;
  else
    return false;
}

bool timesAreEqual(DateTime timeA, DateTime timeB) {
  return (timeA.hour == timeB.hour && timeA.minute == timeB.minute);
}
