import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/modules/itinerary/stop_manager_page.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../providers/gps_provider.dart';

class MonitoringButtons extends StatelessWidget {
  final String itineraryId;

  const MonitoringButtons({super.key, required this.itineraryId});

  Future<void> generateAndShareCSV() async {
    try {
      // Gera o arquivo CSV
      final gpsProvider = GPSProvider(); // Instancia do GPSProvider
      await gpsProvider.generateCSV(itineraryId);

      // Localiza o arquivo CSV
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/locations.csv";
      final file = File(filePath);

      // Verifica se o arquivo existe
      if (!file.existsSync()) {
        print("Arquivo CSV não encontrado!");
        return;
      }

      // Compartilha o arquivo
      await Share.shareXFiles([XFile(filePath)],
          text: "Aqui está o itinerário!");
      print("Arquivo CSV compartilhado com sucesso!");
    } catch (e) {
      print("Erro ao gerar ou compartilhar o arquivo CSV: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final gpsProvider = Provider.of<GPSProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: !gpsProvider.isMonitoring
              ? AppUiConfig.elevatedButtonThemeCustom
              : ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.red)),
          onPressed: gpsProvider.isMonitoring
              ? () => gpsProvider.stopMonitoring()
              : () async {
                  try {
                    await gpsProvider.startMonitoring();
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Erro ao iniciar o monitoramento: $e"),
                        ),
                      );
                    }
                  }
                },
          child: Text(
            gpsProvider.isMonitoring
                ? 'Parar Monitoramento'
                : 'Iniciar Monitoramento',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: AppUiConfig.elevatedButtonThemeCustom,
          onPressed: () async {
            await generateAndShareCSV();
          },
          child: const Text("Gerar e Compartilhar CSV",
              style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: AppUiConfig.elevatedButtonThemeCustom,
          onPressed: () {
            Navigator.of(context).pushNamed(Constants.kDEBUGPAGE);
          },
          child: const Text("Limpar Banco de Dados",
              style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: AppUiConfig.elevatedButtonThemeCustom,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      StopsManagementPage(itineraryId: itineraryId)),
            );
          },
          child: const Text("Gerenciar Pontos de Embarque/Desembarque",
              style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: AppUiConfig.elevatedButtonThemeCustom,
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text("Voltar", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
