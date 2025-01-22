class ForPayment {
  String? id;
  String itinerarieCode;
  String itinerariesShift;
  List<String> schoolsName;
  int schoolsTypeRuralCount;
  int schoolsTypeUrbanCount;
  String trajectory;
  Map<String, int> levels;
  int studentsRural;
  int studentsUrban;
  String vehiclePlate;
  double kilometer;
  String driverName;
  List<String> monitorsName;
  List<String> monitorsId;
  String contract;
  int callDaysCount;
  int callDaysRepositionCount;
  int quantityOfBus;
  DateTime dateOfEvent;
  double valor;

  ForPayment({
    this.id,
    required this.itinerarieCode,
    required this.itinerariesShift,
    required this.schoolsName,
    required this.schoolsTypeRuralCount,
    required this.schoolsTypeUrbanCount,
    required this.trajectory,
    required this.levels,
    required this.studentsUrban,
    required this.studentsRural,
    required this.vehiclePlate,
    required this.kilometer,
    required this.driverName,
    required this.monitorsId,
    required this.contract,
    required this.dateOfEvent,
    required this.valor,
    required this.monitorsName,
    this.callDaysCount = 0,
    this.callDaysRepositionCount = 0,
    this.quantityOfBus = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itinerarieCode': itinerarieCode,
      'itinerariesShift': itinerariesShift,
      'schoolsName': schoolsName,
      'schoolsTypeRuralCount': schoolsTypeRuralCount,
      'schoolsTypeUrbanCount': schoolsTypeUrbanCount,
      'trajectory': trajectory,
      'levels': levels,
      'studentsUrban': studentsUrban,
      'studentsRural': studentsRural,
      'vehiclePlate': vehiclePlate,
      'kilometer': kilometer,
      'driverName': driverName,
      'monitorsId': monitorsId,
      'contract': contract,
      'valor': valor,
      'callDaysCount': callDaysCount,
      'callDaysRepositionCount': callDaysRepositionCount,
      'quantityOfBus': quantityOfBus,
      'dateOfEvent': dateOfEvent.toIso8601String(),
      'monitorsName': monitorsName,
    };
  }

  factory ForPayment.fromJson(Map<String, dynamic> json) {
    return ForPayment(
      id: json['id'],
      itinerarieCode: json['itinerarieCode'],
      itinerariesShift: json['itinerariesShift'],
      schoolsName: List<String>.from(json['schoolsName']),
      schoolsTypeRuralCount: (json['schoolsTypeRuralCount'] as num).toInt(),
      schoolsTypeUrbanCount: (json['schoolsTypeUrbanCount'] as num).toInt(),
      trajectory: json['trajectory'],
      levels: Map<String, int>.from(json['levels']),
      studentsUrban: (json['studentsUrban'] as num).toInt(),
      studentsRural: (json['studentsRural'] as num).toInt(),
      vehiclePlate: json['vehiclePlate'],
      kilometer: (json['kilometer'] as num).toDouble(),
      driverName: json['driverName'],
      monitorsId: List<String>.from(json['monitorsId'] ?? []),
      contract: json['contract'],
      valor: (json['valor'] as num).toDouble(),
      callDaysCount: json['callDaysCount'],
      callDaysRepositionCount: json['callDaysRepositionCount'],
      quantityOfBus: json['quantityOfBus'],
      dateOfEvent: DateTime.parse(json['dateOfEvent']),
      monitorsName: List<String>.from(json['monitorsName']),
    );
  }
}
