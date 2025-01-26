import 'package:flutter/material.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:provider/provider.dart';

import '../../../providers/gps_provider.dart';

class MonitoringButtons extends StatelessWidget {
  final String itineraryId;

  const MonitoringButtons({super.key, required this.itineraryId});

  @override
  Widget build(BuildContext context) {
    final gpsProvider = Provider.of<GPSProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () async {
            final gpsProvider = context.read<GPSProvider>();
            await gpsProvider.generateCSV();
          },
          child: const Text("Gerar CSV",
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                gpsProvider.isMonitoring ? Colors.red : Colors.green,
          ),
          onPressed: gpsProvider.isMonitoring
              ? () => gpsProvider.stopMonitoring()
              : () async {
                  try {
                    await gpsProvider.startMonitoring();
                    print("Monitoramento iniciado com sucesso!");
                  } catch (e) {
                    print("Erro ao iniciar o monitoramento: $e");
                    if (!context.mounted) return;
                    _showPermissionDialog(context);
                  }
                },
          child: Text(
            gpsProvider.isMonitoring
                ? 'Desativar Monitoramento'
                : 'Ativar Monitoramento',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: gpsProvider.locations.isNotEmpty
                ? Colors.blue
                : Colors.grey.shade400,
          ),
          onPressed: gpsProvider.locations.isNotEmpty
              ? () async {
                  await gpsProvider.uploadLocations(itineraryId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Dados enviados com sucesso!'),
                        backgroundColor: AppUiConfig.themeCustom.primaryColor,
                      ),
                    );
                  }
                }
              : null,
          child: const Text(
            'Enviar Dados Manualmente',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissão de Localização Negada'),
        content: const Text(
          'Você precisa permitir o acesso à localização para monitorar o itinerário. '
          'Por favor, vá para as configurações do aplicativo e conceda permissão.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
