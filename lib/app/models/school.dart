class School {
  String? id;
  List<String>? studentsId;
  List<String>? itinerariesId;
  List<String>? appUserId;
  String name,
      phone,
      inep,
      principalName,
      principalRegister,
      secretaryName,
      secretaryRegister,
      type;

  School({
    this.id,
    required this.name,
    required this.phone,
    required this.inep,
    required this.principalName,
    required this.principalRegister,
    required this.secretaryName,
    required this.secretaryRegister,
    required this.type,
    this.studentsId,
    this.appUserId,
    this.itinerariesId,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        inep: json['inep'],
        principalName: json['principalName'],
        principalRegister: json['principalRegister'],
        secretaryName: json['secretaryName'],
        secretaryRegister: json['secretaryRegister'],
        type: json['type'],
        studentsId: List<String>.from(
          json['studentsId'] ?? [],
        ),
        itinerariesId: List<String>.from(
          json['itinerariesId'] ?? [],
        ),
        appUserId: List<String>.from(
          json['appUserId'] ?? [],
        ));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'inep': inep,
      'principalName': principalName,
      'principalRegister': principalRegister,
      'secretaryName': secretaryName,
      'secretaryRegister': secretaryRegister,
      'studentsId': studentsId,
      'itinerariesId': itinerariesId,
      'appUserId': appUserId,
      'type': type,
    };
  }
}
