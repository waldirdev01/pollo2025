import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  bool going;
  bool returning;
  DateTime dateTime;
  bool makeUpDay;
  bool justifiedAbsence;
  bool isSameDay(DateTime other) {
    return dateTime.year == other.year &&
        dateTime.month == other.month &&
        dateTime.day == other.day;
  }

  Attendance({
    required this.going,
    required this.returning,
    required this.dateTime,
    required this.justifiedAbsence,
    this.makeUpDay = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'going': going,
      'returning': returning,
      'justifiedAbsence': justifiedAbsence,
      'dateTime': Timestamp.fromDate(dateTime),
      'makeUpDay': makeUpDay,
    };
  }

  factory Attendance.fromJson(Map<String, dynamic> json) {
    bool going = json['going'] is bool
        ? json['going']
        : json['going'].toLowerCase() == 'true';
    bool returning = json['returning'] is bool
        ? json['returning']
        : json['returning'].toLowerCase() == 'true';
    bool justifiedAbsence = json['justifiedAbsence'] is bool
        ? json['justifiedAbsence']
        : json['justifiedAbsence'].toLowerCase() == 'true';
    bool makeUpDay = json['makeUpDay'] is bool ? json['makeUpDay'] : false;
    return Attendance(
      going: going,
      returning: returning,
      justifiedAbsence: justifiedAbsence,
      dateTime: (json['dateTime'] as Timestamp).toDate(),
      makeUpDay: makeUpDay,
    );
  }
}
