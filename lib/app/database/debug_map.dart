import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:sqflite/sqflite.dart';

import 'gps_database.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  Future<void> clearDatabase(BuildContext context) async {
    // Exibe uma mensagem de sucesso
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Banco de dados limpo!'),
        ),
      );
    }
  }

  Future<void> printAllLocations() async {
    final database = GPSDatabase();
    //final locations = await database.getLocations();
    // print("Localizações armazenadas: $locations");
  }

  Future<void> deleteDatabaseManually() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gps_locations.db');
    await deleteDatabase(path);
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text(
              'Tem certeza de que deseja apagar todas as localizações do banco de dados?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Fecha o diálogo
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Fecha o diálogo
                await clearDatabase(context); // Limpa o banco de dados
              },
              child: const Text(
                'Confirmar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Limpar Banco',
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () => _showConfirmationDialog(context),
          child: const Text(
            'Limpar Banco de Dados',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
