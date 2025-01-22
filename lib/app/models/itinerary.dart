enum TypeItinerary { rural, urban, mix }

extension TypeItineraryExtension on TypeItinerary {
  String get value {
    switch (this) {
      case TypeItinerary.rural:
        return 'RURAL';
      case TypeItinerary.urban:
        return 'URBANO';
      case TypeItinerary.mix:
        return 'MISTO';
    }
  }

  static TypeItinerary fromString(String str) {
    switch (str) {
      case 'RURAL':
        return TypeItinerary.rural;
      case 'URBANO':
        return TypeItinerary.urban;
      case 'MISTO':
        return TypeItinerary.mix;
      default:
        throw ArgumentError('Invalid type itinerary: $str');
    }
  }
}

class Itinerary {
  String? id;
  TypeItinerary type;
  String code;
  String vehiclePlate;
  String driverName;
  String driverPhone;
  String driverLicence;
  int capacity;
  List<String>? studentsId;
  String shift;
  double kilometer;
  String appUserId;
  String trajectory;
  List<String>? schoolIds;
  String contract;
  String? importantAnnotation;

  Itinerary({
    this.id,
    required this.type,
    required this.code,
    required this.vehiclePlate,
    required this.driverName,
    required this.driverLicence,
    required this.driverPhone,
    required this.capacity,
    required this.shift,
    required this.kilometer,
    required this.trajectory,
    required this.contract,
    required this.appUserId,
    this.importantAnnotation,
    this.schoolIds,
    this.studentsId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'code': code,
      'vehiclePlate': vehiclePlate,
      'driverName': driverName,
      'driverLicence': driverLicence,
      'driverPhone': driverPhone,
      'capacity': capacity,
      'shift': shift,
      'kilometer': kilometer,
      'trajectory': trajectory,
      'contract': contract,
      'appUserId': appUserId,
      'importantAnnotation': importantAnnotation,
      'studentsId': studentsId,
      'schoolIds': schoolIds,
    };
  }

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'],
      type: TypeItineraryExtension.fromString(json['type']),
      code: json['code'],
      vehiclePlate: json['vehiclePlate'],
      driverName: json['driverName'],
      driverLicence: json['driverLicence'],
      driverPhone: json['driverPhone'],
      capacity: json['capacity'] as int? ?? 0,
      shift: json['shift'],
      kilometer: (json['kilometer'] as num).toDouble(),
      trajectory: json['trajectory'],
      contract: json['contract'],
      appUserId: json['appUserId'],
      importantAnnotation: json['importantAnnotation'],
      studentsId: List<String>.from(json['studentsId'] ?? []),
      schoolIds: List<String>.from(json['schoolIds'] ?? []),
    );
  }
}
