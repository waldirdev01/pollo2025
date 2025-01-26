import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  Future<void> startMonitoring() async {
    final hasPermission = await _checkPermissions();
    if (!hasPermission) {
      throw Exception('Permissões de localização necessárias!');
    }

    if (_isMonitoring) return;

    _isMonitoring = true;
    notifyListeners();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) async {
      final location = {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': position.timestamp.toIso8601String(),
      };
      print("ponto: lat: ${position.latitude}, long: ${position.longitude}");
      _locations.add(location);
      notifyListeners();

      // Salva no SQLite
      await _database.insertLocation(location);
    });
  }

  void stopMonitoring() {
    _isMonitoring = false;
    _positionStream?.cancel();
    _positionStream = null;
    notifyListeners();
  }

  Future<void> uploadLocations(String itineraryId) async {
    final localLocations = await _database.getLocations();

    // Verifica se existem dados a enviar
    if (localLocations.isEmpty) {
      return;
    }

    try {
      final batch = FirebaseFirestore.instance.batch();
      final ref = FirebaseFirestore.instance
          .collection('itineraries')
          .doc(itineraryId)
          .collection('locations');

      Map<String, dynamic>? previousLocation;

      for (final location in localLocations) {
        // Calcula a distância entre pontos
        if (previousLocation != null) {
          final distance = Geolocator.distanceBetween(
            previousLocation['latitude'] as double,
            previousLocation['longitude'] as double,
            location['latitude'] as double,
            location['longitude'] as double,
          );

          if (distance > 10000) {
            print("Ponto ignorado por distância: $location");
            continue;
          }
        }

        final docRef = ref.doc();
        batch.set(docRef, location);
        previousLocation = location;
      }

      // Envia o batch para o Firebase
      await batch.commit();

      // Limpa os dados locais após o envio bem-sucedido
      await _database.clearLocations();
      _locations.clear();
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao enviar dados: $e');
    }
  }

  Future<void> generateCSV() async {
    // Obtém as localizações salvas no banco
    final localLocations = await _database.getLocations();

    // Verifica se existem dados
    if (localLocations.isEmpty) {
      print("Nenhuma localização disponível para gerar o CSV.");
      return;
    }

    try {
      // Cria o cabeçalho do CSV
      String csvContent = "latitude,longitude,timestamp\n";

      // Adiciona cada linha
      for (var location in localLocations) {
        final lat = location['latitude'];
        final lng = location['longitude'];
        final timestamp = location['timestamp'];
        csvContent += "$lat,$lng,$timestamp\n";
      }

      // Obtém o diretório para salvar o arquivo
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/locations.csv";

      // Salva o arquivo
      final file = File(filePath);
      await file.writeAsString(csvContent);

      print("CSV criado com sucesso em: $filePath");
    } catch (e) {
      print("Erro ao criar CSV: $e");
    }
  }
}
