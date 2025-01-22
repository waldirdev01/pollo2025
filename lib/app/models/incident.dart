class Incident {
  String? id;
  String studentId;
  DateTime dateCreate;
  DateTime dateCient;
  String description;
  String appUserName;
  bool cient;

  Incident({
    required this.studentId,
    required this.dateCreate,
    required this.description,
    required this.appUserName,
    required this.dateCient,
    this.cient = false,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId' :studentId,
      'dateCreate': dateCreate.toIso8601String(),
      'description': description,
      'appUserName': appUserName,
      'cient': cient,
      'dateCient': dateCient.toIso8601String(),
    };
  }

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'],
        studentId: json['studentId'],
        dateCreate: DateTime.parse(json['dateCreate']),
        description: json['description'],
        appUserName: json['appUserName'],
        cient: json['cient'],
        dateCient: DateTime.parse(json['dateCient']));
  }
}
