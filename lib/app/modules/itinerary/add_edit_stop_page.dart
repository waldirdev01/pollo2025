import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';

import '../../core/widgets/custom_app_bar.dart';
import '../../database/gps_database.dart';

class AddOrEditStopPage extends StatefulWidget {
  final String itineraryId;
  final Map<String, dynamic>? stop;

  const AddOrEditStopPage({
    super.key,
    required this.itineraryId,
    this.stop,
  });

  @override
  State<AddOrEditStopPage> createState() => _AddOrEditStopPageState();
}

class _AddOrEditStopPageState extends State<AddOrEditStopPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  String? _selectedShift = "Matutino";
  String? _selectedDirection = "Ida";
  bool _isSaving =
      false; // Estado para controlar o botão e exibir o indicador de carregamento

  @override
  void initState() {
    super.initState();
    if (widget.stop != null) {
      _titleController.text = widget.stop!['title'];
      _selectedShift = widget.stop!['shift'];
      _selectedDirection = widget.stop!['direction'];
    }
  }

  /// Verifica e solicita permissões de localização
  Future<bool> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppUiConfig.themeCustom.primaryColor,
            content: const Text(
                'Permissão de localização negada. Ative nas configurações.'),
          ),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppUiConfig.themeCustom.primaryColor,
          content: Text('Permissão de localização negada permanentemente.'),
        ),
      );
      return false;
    }

    return true;
  }

  /// Salva o stop no banco de dados
  Future<void> _saveStop() async {
    if (!_formKey.currentState!.validate()) return;

    final hasPermission = await _checkPermissions();
    if (!hasPermission) return;

    setState(() {
      _isSaving =
          true; // Desabilita o botão e exibe o indicador de carregamento
    });

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final stop = {
        'itineraryId': widget.itineraryId,
        'title': _titleController.text,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'time': DateTime.now().toIso8601String(),
        'shift': _selectedShift,
        'direction': _selectedDirection,
      };

      final db = GPSDatabase();

      if (widget.stop == null) {
        // Adiciona um novo stop
        await db.insertStop(stop);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: AppUiConfig.themeCustom.primaryColor,
              content: Text('Ponto salvo com sucesso!')),
        );
      } else {
        // Atualiza um stop existente
        stop['id'] = widget.stop!['id'];
        await db.updateStop(stop);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ponto atualizado com sucesso!')),
        );
      }

      Navigator.pop(context); // Retorna para a página anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppUiConfig.themeCustom.primaryColor,
          content: Text('Erro ao salvar o ponto: $e'),
        ),
      );
    } finally {
      setState(() {
        _isSaving = false; // Reabilita o botão
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.stop == null ? 'Adicionar Ponto' : 'Editar Ponto',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título do Ponto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedShift,
                items: const [
                  DropdownMenuItem(
                    value: "Matutino",
                    child: Text("Matutino"),
                  ),
                  DropdownMenuItem(
                    value: "Vespertino",
                    child: Text("Vespertino"),
                  ),
                  DropdownMenuItem(
                    value: "Noturno",
                    child: Text("Noturno"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedShift = value;
                  });
                },
                decoration: const InputDecoration(labelText: "Turno"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDirection,
                items: const [
                  DropdownMenuItem(
                    value: "Ida",
                    child: Text("Ida"),
                  ),
                  DropdownMenuItem(
                    value: "Volta",
                    child: Text("Volta"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDirection = value;
                  });
                },
                decoration: const InputDecoration(labelText: "Direção"),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: AppUiConfig.elevatedButtonThemeCustom,
                onPressed: _isSaving
                    ? null // Desabilita o botão enquanto está salvando
                    : _saveStop,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : Text(
                        widget.stop == null ? 'Salvar' : 'Atualizar',
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
