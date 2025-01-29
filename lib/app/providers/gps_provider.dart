import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';

import '../database/gps_database.dart';

class GPSProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _locations = [];
  StreamSubscription<Position>? _positionStream;
  bool _isMonitoring = false;

  List<Map<String, dynamic>> get locations => _locations;
  bool get isMonitoring => _isMonitoring;

  final GPSDatabase _database = GPSDatabase();

  /// Verifica permissões de localização
  Future<bool> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Inicia o monitoramento do GPS
  Future<void> startMonitoring() async {
    final hasPermission = await _checkPermissions();
    if (!hasPermission) {
      throw Exception('Permissões de localização necessárias!');
    }

    if (_isMonitoring) return;

    _isMonitoring = true;
    notifyListeners();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20,
      ),
    ).listen(
      (Position position) async {
        final location = {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': position.timestamp.toIso8601String(),
          'date': DateTime.now().toString().split(" ")[0],
        };

        await _database.insertLocation(location);

        _locations.add(location);
        notifyListeners();
      },
      onError: (error) {
        print("Erro ao monitorar: $error");
      },
    );
  }

  void stopMonitoring() {
    _isMonitoring = false;
    _positionStream?.cancel();
    _positionStream = null;
    notifyListeners();
  }

  /// Gera CSV de localizações
  Future<void> generateCSV(String itineraryId) async {
    final locations = await _database.getLocations();

    if (locations.isEmpty) return;

    String csvContent = "latitude,longitude,timestamp,itinerary_id\n";

    for (var location in locations) {
      final timestamp = DateTime.parse(location['timestamp']).toLocal();
      csvContent +=
          "${location['latitude']},${location['longitude']},${timestamp.toIso8601String()},$itineraryId\n";
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/locations.csv";
    await File(filePath).writeAsString(csvContent);
  }

  /// Gera CSV de stops
  Future<void> generateStopsCSV(String itineraryId) async {
    final stops = await _database.getStops(itineraryId);

    if (stops.isEmpty) return;

    String csvContent =
        "title,latitude,longitude,time,shift,direction,itinerary_id\n";

    for (var stop in stops) {
      csvContent +=
          "${stop['title']},${stop['latitude']},${stop['longitude']},${stop['time']},${stop['shift']},${stop['direction']},$itineraryId\n";
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/stops.csv";
    await File(filePath).writeAsString(csvContent);
  }
}
