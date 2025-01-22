import 'package:pollo2025/app/models/e_c_student.dart';

enum Subject {
  portuguese,
  math,
  history,
  geography,
  science,
  art,
  physicalEducation,
  english,
  spanish,
  philosophy,
  sociology,
  biology,
  physics,
  chemistry,
  interdisciplinar,
}

extension SubjectsExtension on Subject {
  String get name {
    switch (this) {
      case Subject.portuguese:
        return 'Português';
      case Subject.math:
        return 'Matemática';
      case Subject.history:
        return 'História';
      case Subject.geography:
        return 'Geografia';
      case Subject.science:
        return 'Ciências';
      case Subject.art:
        return 'Artes';
      case Subject.physicalEducation:
        return 'Educação Física';
      case Subject.english:
        return 'Inglês';
      case Subject.spanish:
        return 'Espanhol';
      case Subject.philosophy:
        return 'Filosofia';
      case Subject.sociology:
        return 'Sociologia';
      case Subject.biology:
        return 'Biologia';
      case Subject.physics:
        return 'Física';
      case Subject.chemistry:
        return 'Química';
      case Subject.interdisciplinar:
        return 'Interdisciplinar';
    }
  }

  static Subject fromString(String value) {
    switch (value) {
      case 'Português':
        return Subject.portuguese;
      case 'Matemática':
        return Subject.math;
      case 'História':
        return Subject.history;
      case 'Geografia':
        return Subject.geography;
      case 'Ciências':
        return Subject.science;
      case 'Artes':
        return Subject.art;
      case 'Educação Física':
        return Subject.physicalEducation;
      case 'Inglês':
        return Subject.english;
      case 'Espanhol':
        return Subject.spanish;
      case 'Filosofia':
        return Subject.philosophy;
      case 'Sociologia':
        return Subject.sociology;
      case 'Biologia':
        return Subject.biology;
      case 'Física':
        return Subject.physics;
      case 'Química':
        return Subject.chemistry;
      case 'Interdisciplinar':
        return Subject.interdisciplinar;
      default:
        throw ArgumentError('Invalid value: $value');
    }
  }
}

class ExtracurricularActivity {
  String? id;
  String memo;
  String contract;
  String schoolId;
  String tcbCode;
  String title;
  String local;
  String setOfThemes;
  String skillsToDevelop;
  Subject subject;
  DateTime dateOfCreate;
  DateTime dateOfEvent;
  String leaveMorning;
  String returnMorning;
  String leaveAfternoon;
  String returnAfternoon;
  String leaveNight;
  String returnNight;
  String busDriver;
  String busPlate;
  String driverPhone;
  List<String> monitorsId;
  int quantityOfBus;
  double kilometerOfBus;
  String teachers;
  List<ECStudent> students;
  bool isDone;

  ExtracurricularActivity({
    this.id,
    required this.contract,
    required this.memo,
    required this.schoolId,
    required this.title,
    required this.tcbCode,
    required this.local,
    required this.setOfThemes,
    required this.skillsToDevelop,
    required this.subject,
    required this.dateOfCreate,
    required this.dateOfEvent,
    required this.leaveMorning,
    required this.returnMorning,
    required this.leaveAfternoon,
    required this.returnAfternoon,
    required this.leaveNight,
    required this.returnNight,
    required this.busDriver,
    required this.busPlate,
    required this.driverPhone,
    required this.monitorsId,
    required this.quantityOfBus,
    required this.kilometerOfBus,
    required this.teachers,
    required this.students,
    required this.isDone,
  });

  factory ExtracurricularActivity.fromJson(Map<String, dynamic> json) {
    return ExtracurricularActivity(
      id: json['id'],
      contract: json['contract'],
      memo: json['memo'],
      schoolId: json['schoolId'],
      tcbCode: json['tcbCode'],
      local: json['local'],
      title: json['title'],
      setOfThemes: json['setOfThemes'],
      skillsToDevelop: json['skillsToDevelop'],
      subject: SubjectsExtension.fromString(json['subject']),
      dateOfCreate: DateTime.parse(json['dateOfCreate']),
      dateOfEvent: DateTime.parse(json['dateOfEvent']),
      leaveMorning: json['leaveMorning'],
      returnMorning: json['returnMorning'],
      leaveAfternoon: json['leaveAfternoon'],
      returnAfternoon: json['returnAfternoon'],
      leaveNight: json['leaveNight'],
      returnNight: json['returnNight'],
      busDriver: json['busDriver'],
      busPlate: json['busPlate'],
      driverPhone: json['driverPhone'],
      monitorsId: List<String>.from((json['monitorsId'] ?? [])),
      quantityOfBus: json['quantityOfBus'] as int? ?? 0,
      kilometerOfBus: (json['kilometerOfBus'] as num).toDouble(),
      teachers: json['teachers'],
      students:
          (json['students'] as List).map((e) => ECStudent.fromJson(e)).toList(),
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contract': contract,
      'memo': memo,
      'schoolId': schoolId,
      'title': title,
      'tcbCode': tcbCode,
      'setOfThemes': setOfThemes,
      'skillsToDevelop': skillsToDevelop,
      'subject': subject.name,
      'local': local,
      'dateOfCreate': dateOfCreate.toIso8601String(),
      'dateOfEvent': dateOfEvent.toIso8601String(),
      'leaveMorning': leaveMorning,
      'returnMorning': returnMorning,
      'leaveAfternoon': leaveAfternoon,
      'returnAfternoon': returnAfternoon,
      'leaveNight': leaveNight,
      'returnNight': returnNight,
      'busDriver': busDriver,
      'busPlate': busPlate,
      'driverPhone': driverPhone,
      'monitorsId': monitorsId,
      'quantityOfBus': quantityOfBus,
      'kilometerOfBus': kilometerOfBus,
      'teachers': teachers,
      'students': students.map((e) => e.toJson()).toList(),
      'isDone': isDone,
    };
  }
}
