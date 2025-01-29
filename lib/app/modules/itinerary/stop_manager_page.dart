import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:share_plus/share_plus.dart';

import '../../database/gps_database.dart';
import '../../providers/gps_provider.dart';
import 'add_edit_stop_page.dart';

class StopsManagementPage extends StatefulWidget {
  final String itineraryId;

  const StopsManagementPage({super.key, required this.itineraryId});

  @override
  State<StopsManagementPage> createState() => _StopsManagementPageState();
}

class _StopsManagementPageState extends State<StopsManagementPage> {
  late Future<List<Map<String, dynamic>>> _stopsFuture;

  @override
  void initState() {
    super.initState();
    _fetchStops();
  }

  void _fetchStops() {
    final db = GPSDatabase();
    setState(() {
      _stopsFuture = db.getStops(widget.itineraryId);
    });
  }

  Future<void> _deleteStop(int id) async {
    final db = GPSDatabase();

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar Exclusão"),
          content: const Text("Tem certeza que deseja excluir este ponto?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "Excluir",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await db.deleteStop(id);
      _fetchStops(); // Atualiza a lista após deletar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ponto deletado com sucesso!")),
      );
    }
  }

  /// Método para gerar e compartilhar o CSV dos stops
  Future<void> _generateAndShareStopsCSV() async {
    try {
      final gpsProvider = GPSProvider();
      await gpsProvider.generateStopsCSV(widget.itineraryId);

      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/stops.csv";
      final file = File(filePath);

      if (!file.existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nenhum arquivo CSV encontrado.")),
        );
        return;
      }

      await Share.shareXFiles(
        [XFile(filePath)],
        text: "Aqui está o CSV com os pontos de embarque/desembarque!",
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao gerar ou compartilhar o CSV: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: ('Gerenciar Pontos de Embarque/Desembarque'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _stopsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Erro ao carregar os pontos: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum ponto cadastrado.'));
          }

          final stops = snapshot.data!;

          return ListView.builder(
            itemCount: stops.length,
            itemBuilder: (context, index) {
              final stop = stops[index];
              final parsedTime = DateTime.parse(stop['time']);
              final formattedTime = DateFormat('HH:mm').format(parsedTime);
              return Card(
                margin: const EdgeInsets.all(8),
                color: Theme.of(context).primaryColor,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text(stop['title'],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    "Horário: $formattedTime | Turno: ${stop['shift']} | Direção: ${stop['direction']}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => AddOrEditStopPage(
                                    itineraryId: widget.itineraryId,
                                    stop: stop,
                                  ),
                                ),
                              )
                              .then((_) => _fetchStops());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteStop(stop['id']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "add_stop",
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) =>
                          AddOrEditStopPage(itineraryId: widget.itineraryId),
                    ),
                  )
                  .then((_) => _fetchStops());
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "share_csv",
            backgroundColor: AppUiConfig.themeCustom.primaryColor,
            onPressed: _generateAndShareStopsCSV,
            child: const Icon(Icons.share, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
