import 'package:pollo2025/app/models/pne.dart';

import 'attendance.dart';

class Student {
  String? id;
  String? imageUrl;
  String name;
  String ieducar;
  String level;
  String schoolId;
  String cpf;
  bool authorized;
  PNE pne;
  String residenceType;
  String itineraryId;
  String classroomGrade;
  bool requiresGuardian;
  List<Attendance> attendance;
  DateTime createdAt;
  List<String> incidentsId;
  String differentiated;
  Student({
    this.id,
    this.imageUrl,
    required this.name,
    required this.ieducar,
    required this.level,
    required this.schoolId,
    required this.cpf,
    this.authorized = false,
    required this.itineraryId,
    required this.pne,
    required this.residenceType,
    required this.classroomGrade,
    this.requiresGuardian = false,
    this.differentiated = '',
    required this.attendance,
    required this.createdAt,
    required this.incidentsId,
  });

  Student copyWith({
    String? id,
    String? imageUrl,
    String? name,
    String? ieducar,
    String? level,
    String? schoolId,
    String? cpf,
    bool? authorized,
    PNE? pne,
    String? residenceType,
    String? itineraryId,
    String? classroomGrade,
    String? differentiated,
    bool? requiresGuardian,
    List<Attendance>? attendance,
    DateTime? createdAt,
    List<String>? incidentsId,
  }) {
    return Student(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      ieducar: ieducar ?? this.ieducar,
      level: level ?? this.level,
      schoolId: schoolId ?? this.schoolId,
      cpf: cpf ?? this.cpf,
      authorized: authorized ?? this.authorized,
      requiresGuardian: requiresGuardian ?? this.requiresGuardian,
      pne: pne ?? this.pne,
      differentiated: differentiated ?? this.differentiated,
      residenceType: residenceType ?? this.residenceType,
      itineraryId: itineraryId ?? this.itineraryId,
      classroomGrade: classroomGrade ?? this.classroomGrade,
      attendance: attendance ?? this.attendance,
      createdAt: createdAt ?? this.createdAt,
      incidentsId: incidentsId ?? this.incidentsId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'ieducar': ieducar,
      'level': level,
      'schoolId': schoolId,
      'cpf': cpf,
      'authorized': authorized,
      'requiresGuardian': requiresGuardian,
      'pne': pne.toJson(),
      'residenceType': residenceType,
      'itineraryId': itineraryId,
      'classroom': classroomGrade,
      'differentiated': differentiated,
      'attendance': attendance.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'incidents': incidentsId,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        id: json['id'],
        imageUrl: json['imageUrl'],
        name: json['name'],
        ieducar: json['ieducar'],
        level: json['level'],
        schoolId: json['schoolId'],
        cpf: json['cpf'],
        residenceType: json['residenceType'],
        authorized: json['authorized'],
        requiresGuardian: json['requiresGuardian'],
        pne: PNE.fromJson(json['pne']),
        itineraryId: json['itineraryId'],
        classroomGrade: json['classroom'],
        differentiated: json['differentiated'],
        attendance: (json['attendance'] as List)
            .map((e) => Attendance.fromJson(e))
            .toList(),
        createdAt: DateTime.parse(json['createdAt']),
        incidentsId: List<String>.from(
          json['incidentsId'] ?? [],
        ));
  }

  void toggleGoing(Attendance attendance) {
    attendance.going = !attendance.going;
  }

  void toggleReturning(Attendance attendance) {
    attendance.returning = !attendance.returning;
  }

  int countAbsences() {
    int absenceCount = 0;
    for (var att in attendance) {
      // Aumenta a contagem apenas se não for uma falta justificada
      if (!att.going && !att.justifiedAbsence) absenceCount++;
      if (!att.returning && !att.justifiedAbsence) absenceCount++;
    }
    return absenceCount;
  }
}
