// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/ui/messages.dart';
import '../../core/widgets/app_field.dart';
import '../../models/itinerary.dart';
import '../../providers/itinerary_provider.dart';

class ItineraryCreateForm extends StatefulWidget {
  const ItineraryCreateForm({super.key});

  @override
  _ItineraryCreateFormState createState() => _ItineraryCreateFormState();
}

class _ItineraryCreateFormState extends State<ItineraryCreateForm> {
  String _contract = '12/2024';
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _vehiclePlate = TextEditingController();
  final _driverName = TextEditingController();
  int _capacity = 0;
  final _driverLicence = TextEditingController();
  final _driverPhone = TextEditingController();
  String _shift = 'MATUTINO';
  String _typeItinerary = 'URBANO';
  double _kilometer = 0;
  final _kilometerEC = TextEditingController();
  final _capacityEC = TextEditingController();
  final _description = TextEditingController();
  final _annotation = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    _vehiclePlate.dispose();
    _driverName.dispose();
    _driverLicence.dispose();
    _driverPhone.dispose();
    _description.dispose();
    _annotation.dispose();
    _capacityEC.dispose();
    _kilometerEC.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (formValid) {
      // Adiciona esta linha para chamar onSaved em cada TextFormField
      _formKey.currentState?.save();
      _capacity = int.tryParse(_capacityEC.text) ?? 0;

      try {
        final itinerary = Itinerary(
          code: _code.text,
          type: TypeItinerary.urban,
          appUserId: '',
          vehiclePlate: _vehiclePlate.text,
          driverName: _driverName.text,
          capacity: _capacity,
          driverLicence: _driverLicence.text,
          driverPhone: _driverPhone.text,
          shift: _shift,
          kilometer: _kilometer,
          trajectory: _description.text,
          contract: _contract,
          importantAnnotation: _annotation.text,
        );

        await context
            .read<ItineraryProvider>()
            .createItinerary(itinerary: itinerary);
        Messages.of(context).showInfo('Itinerário criado com sucesso');
      } on FirebaseException catch (e) {
        Messages.of(context).showError('Erro ao criar itinerário $e');
      } finally {
        // Limpeza dos campos pode ser mantida
        _clearFormFields();
      }
    }
  }

  void _clearFormFields() {
    setState(() {
      _annotation.clear();
      _code.clear();
      _description.clear();
      _driverLicence.clear();
      _driverName.clear();
      _driverPhone.clear();
      _vehiclePlate.clear();
      _kilometerEC.clear();
      _capacityEC.clear();
      _capacity = 0;
      _kilometer = 0.0;
      _typeItinerary = 'URBANO';
      _shift = 'MATUTINO';
      _contract = '20/2022';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Itinerário'),
        iconTheme: AppUiConfig.iconThemeCustom(),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppField(
                  label: 'Código',
                  controller: _code,
                  validator: Validatorless.required('Informe o código')),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                  decoration: const InputDecoration(
                      labelText: 'Contrato',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                  items: const [
                    DropdownMenuItem(value: '12/2024', child: Text('12/2024')),
                    DropdownMenuItem(value: '20/2022', child: Text('20/2022')),
                    DropdownMenuItem(value: '02/2023', child: Text('02/2023')),
                    DropdownMenuItem(value: '63/2021', child: Text('63/2021')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _contract = value as String;
                    });
                  }),
              const SizedBox(height: 10),
              AppField(
                label: 'Placa do Veículo',
                controller: _vehiclePlate,
                validator: Validatorless.required('Informe a placa do veículo'),
              ),
              const SizedBox(height: 10),
              AppField(
                label: 'Nome do Motorista',
                controller: _driverName,
                validator:
                    Validatorless.required('Informe o nome do motorista'),
              ),
              const SizedBox(height: 10),
              AppField(
                label: 'CNH',
                controller: _driverLicence,
                validator: Validatorless.required('Informe a CNH'),
              ),
              const SizedBox(height: 10),
              AppField(
                label: 'Telefone do Motorista',
                controller: _driverPhone,
                validator:
                    Validatorless.required('Informe o telefone do motorista'),
              ),
              const SizedBox(height: 10),
              AppField(
                label: 'Capacidade',
                controller: _capacityEC,
                validator: Validatorless.required('Informe a capacidade'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _kilometerEC,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+(,\d{0,2})?$')),
                ],
                decoration: InputDecoration(
                    labelText: 'Quilometragem',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                onSaved: (value) {
                  final formattedValue = value?.replaceAll(',', '.');
                  _kilometer = double.tryParse(formattedValue ?? '')!;
                },
                validator: (value) {
                  if (value != null && value.contains('.')) {
                    return 'Use vírgula como separador decimal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                    labelText: 'Turno',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
                value: _shift,
                onChanged: (newValue) {
                  setState(() {
                    _shift = newValue as String;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: 'MATUTINO',
                    child: Text('MATUTINO'),
                  ),
                  DropdownMenuItem(
                    value: 'VESPERTINO',
                    child: Text('VESPERTINO'),
                  ),
                  DropdownMenuItem(
                    value: 'NOTURNO',
                    child: Text('NOTURNO'),
                  ),
                  DropdownMenuItem(
                    value: 'INTEGRAL',
                    child: Text('INTEGRAL'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                    labelText: 'Tipo de Itinerário',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
                value: _typeItinerary,
                onChanged: (newValue) {
                  setState(() {
                    _typeItinerary = newValue as String;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: 'URBANO',
                    child: Text('URBANO'),
                  ),
                  DropdownMenuItem(
                    value: 'RURAL',
                    child: Text('RURAL'),
                  ),
                  DropdownMenuItem(
                    value: 'MISTO',
                    child: Text('MISTO'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: AppUiConfig.elevatedButtonThemeCustom,
                onPressed: _submitForm,
                child: const Text('Adicionar Itinerário',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
