import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/providers/itinerary_provider.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/ui/ap_ui_config.dart';
import '../../models/itinerary.dart';

class ItineraryEditForm extends StatefulWidget {
  const ItineraryEditForm({super.key});

  @override
  State<ItineraryEditForm> createState() => _ItineraryEditFormState();
}

class _ItineraryEditFormState extends State<ItineraryEditForm> {
  final _formKey = GlobalKey<FormState>();
  String? _contract;

  @override
  Widget build(BuildContext context) {
    final itinerary = ModalRoute.of(context)!.settings.arguments as Itinerary;

    setState(() {
      _contract = itinerary.contract;
    });

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Editar itinerário',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                TextFormField(
                  initialValue: itinerary.code,
                  decoration: const InputDecoration(
                    labelText: 'Código do itinerário',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  onSaved: (value) => itinerary.code = value!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: itinerary.capacity.toString(),
                  decoration: InputDecoration(
                    labelText: 'Capacidade',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onSaved: (value) {
                    itinerary.capacity = int.tryParse(value ?? '')!;
                  },
                  validator: Validatorless.required('Informe a capacidade'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: itinerary.kilometer.toString(),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+(,\d{0,2})?$')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Quilometragem',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onSaved: (value) {
                    final formattedValue = value?.replaceAll(',', '.');
                    itinerary.kilometer =
                        double.tryParse(formattedValue ?? '')!;
                  },
                  validator: (value) {
                    if (value != null && value.contains('.')) {
                      return 'Use vírgula como separador decimal';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: itinerary.trajectory,
                  decoration: const InputDecoration(
                    labelText: 'Descrição do itinerário',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  onSaved: (value) => itinerary.trajectory = value!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: itinerary.vehiclePlate,
                  decoration: const InputDecoration(
                    labelText: 'Placa do veículo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  onSaved: (value) => itinerary.vehiclePlate = value!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: itinerary.driverName,
                  decoration: const InputDecoration(
                    labelText: 'Nome do motorista',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  onSaved: (value) => itinerary.driverName = value!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: itinerary.driverLicence,
                  decoration: const InputDecoration(
                    labelText: 'CNH do motorista',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  onSaved: (value) => itinerary.driverLicence = value!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: itinerary.driverPhone,
                  decoration: const InputDecoration(
                    labelText: 'Telefone do motorista',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  onSaved: (value) => itinerary.driverPhone = value!,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Contrato',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: '12/2024',
                      child: Text('12/2024'),
                    ),
                    DropdownMenuItem(
                      value: '20/2022',
                      child: Text('20/2022'),
                    ),
                    DropdownMenuItem(
                      value: '02/2023',
                      child: Text('02/2023'),
                    ),
                    DropdownMenuItem(
                      value: '63/2021',
                      child: Text('63/2021'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _contract = value;
                    });
                  },
                  value: _contract,
                  onSaved: (value) => itinerary.contract = value!,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Turno',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  value: itinerary.shift,
                  onChanged: (newValue) {
                    setState(() {
                      itinerary.shift = newValue!;
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
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Itinerário',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  value: itinerary.type.value,
                  onChanged: (newValue) {
                    setState(() {
                      itinerary.type = TypeItinerary.values
                          .firstWhere((element) => element.value == newValue);
                    });
                  },
                  items: TypeItinerary.values
                      .map((e) => DropdownMenuItem(
                            value: e.value,
                            child: Text(e.value),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: AppUiConfig.elevatedButtonThemeCustom,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      context
                          .read<ItineraryProvider>()
                          .updateItinerary(itinerary);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Editar Itinerário',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
