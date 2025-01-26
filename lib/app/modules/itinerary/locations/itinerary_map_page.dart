import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ItineraryMapPage extends StatefulWidget {
  final String itineraryId;

  const ItineraryMapPage({super.key, required this.itineraryId});

  @override
  State<ItineraryMapPage> createState() => _ItineraryMapPageState();
}

class _ItineraryMapPageState extends State<ItineraryMapPage> {
  final Set<Polyline> _polylines = {};
  final List<LatLng> _routePoints = [];
  LatLng? _initialPosition;

  @override
  void initState() {
    super.initState();
    _fetchRouteData();
  }

  Future<void> _fetchRouteData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('itineraries')
          .doc(widget.itineraryId)
          .collection('locations')
          .orderBy('timestamp')
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final lat = data['latitude'] as double; // Verifique se é double
          final lng = data['longitude'] as double; // Verifique se é double

          // Certifique-se de que os valores são válidos
          if (lat.abs() > 90 || lng.abs() > 180) {
            print("Coordenadas inválidas ignoradas: $lat, $lng");
            continue;
          }

          _routePoints.add(LatLng(lat, lng));
        }

        setState(() {
          _initialPosition = _routePoints.first;
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: _routePoints,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Nenhum dado de localização encontrado.')),
        );
      }
    } catch (e) {
      print("Erro ao buscar os dados: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rota no Mapa')),
      body: _initialPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition!,
                zoom: 15,
              ),
              polylines: _polylines,
              markers: _routePoints
                  .map((point) => Marker(
                        markerId: MarkerId(point.toString()),
                        position: point,
                      ))
                  .toSet(),
            ),
    );
  }
}
