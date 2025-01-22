class ECStudent {
  String? id;
  String name;
  String ieducarCode;
  bool present;
  String schoolId;
  String level;
  String typeResidence;

  ECStudent({
    this.id,
    required this.name,
    required this.ieducarCode,
    required this.schoolId,
    required this.typeResidence,
    required this.level,
    this.present = true,
  });

  factory ECStudent.fromJson(Map<String, dynamic> json) {
    return ECStudent(
      id: json['id'],
      name: json['name'],
      ieducarCode: json['ieducar_code'],
      typeResidence: json['type_residence'],
      schoolId: json['school_id'],
      level: json['level'],
      present: json['present'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ieducar_code': ieducarCode,
      'type_residence': typeResidence,
      'present': present,
      'school_id': schoolId,
      'level': level,
    };
  }
}
