import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/extracurricular_activity.dart';
import 'package:pollo2025/app/providers/e_c_activity_provider.dart';
import 'package:validatorless/validatorless.dart';

import '../../../models/school.dart';

class ECCreateForm extends StatefulWidget {
  const ECCreateForm({super.key});

  @override
  State<ECCreateForm> createState() => _ECCreateFormState();
}

class _ECCreateFormState extends State<ECCreateForm> {
  late School school;
  String _contract = '45/2021';
  DateTime _dateOfEvent = DateTime.now();
  Subject subject = Subject.interdisciplinar;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _localController = TextEditingController();
  final _setOfThemesController = TextEditingController();
  final _skillsToDevelopController = TextEditingController();
  final _leaveoMorningController = TextEditingController();
  final _returnMorningController = TextEditingController();
  final _leaveAfternoonController = TextEditingController();
  final _returnAfternoonController = TextEditingController();
  final _leaveNightController = TextEditingController();
  final _returnNightController = TextEditingController();
  final _quantityOfBusController = TextEditingController();
  final _kilometerOfBusController = TextEditingController();
  final _teachersController = TextEditingController();
  final _memoController = TextEditingController();
  String saidaManha = '';
  String retornoManha = '';
  String saidaTarde = '';
  String retornoTarde = '';
  String saidaNoite = '';
  String retornoNoite = '';
  double km = 0.0;
  int qtd = 0;

  Future<void> _selectDateOfEvent(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfEvent,
      firstDate: DateTime(2023),
      lastDate: DateTime(2028),
    );

    if (picked != null && picked != _dateOfEvent) {
      setState(() {
        _dateOfEvent = picked;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _setOfThemesController.dispose();
    _skillsToDevelopController.dispose();
    _leaveoMorningController.dispose();
    _returnMorningController.dispose();
    _leaveAfternoonController.dispose();
    _returnAfternoonController.dispose();
    _leaveNightController.dispose();
    _returnNightController.dispose();
    _quantityOfBusController.dispose();
    _kilometerOfBusController.dispose();
    _teachersController.dispose();
    _localController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schoolLoaded = ModalRoute.of(context)!.settings.arguments as School;
    school = schoolLoaded;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Criar atividade',
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(DateFormat('dd/MM/yyyy').format(_dateOfEvent)),
                  TextButton(
                    onPressed: () => _selectDateOfEvent(context),
                    child: const Text('Selecionar data do evento'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _memoController,
              decoration: const InputDecoration(
                  labelText: 'Número do memorando',
                  hintText: 'ex: 24/2024',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                  labelText: 'Temática',
                  hintText: 'ex: Arte Circense',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Informe um título';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
                decoration: const InputDecoration(
                    labelText: 'Contrato',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
                items: const [
                  DropdownMenuItem(
                    value: '45/2021',
                    child: Text('45/2021'),
                  ),
                  DropdownMenuItem(
                    value: '41/2021',
                    child: Text('41/2021'),
                  ),
                ],
                value: _contract,
                onChanged: (value) {
                  setState(() {
                    _contract = value.toString();
                  });
                }),
            const SizedBox(height: 10),
            TextFormField(
              controller: _localController,
              decoration: const InputDecoration(
                  labelText: 'Local',
                  hintText: 'Nome do local e/ou endereço',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Informe um local';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _setOfThemesController,
              decoration: const InputDecoration(
                  labelText: 'Conteúdos e habilidades do currículo',
                  hintText: 'ex: Arte e cultura, corpo e movimento, etc.',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Informe um conjunto de temas';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _skillsToDevelopController,
              decoration: const InputDecoration(
                  labelText:
                      'Possíveis habilidades desenvolvidas após a atividade',
                  hintText: 'ex: Criatividade, autonomia, etc.',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Informe as habilidades a desenvolver';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<Subject>(
              decoration: const InputDecoration(
                  labelText: 'Disciplinas',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
              value: subject,
              onChanged: (Subject? newValue) {
                setState(() {
                  subject = newValue!;
                });
              },
              items: Subject.values
                  .map((Subject subject) => DropdownMenuItem<Subject>(
                        value: subject,
                        child: Text(subject.name.toString()),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Informe a disciplina';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _leaveoMorningController,
              decoration: const InputDecoration(
                  labelText: 'Saída manhã',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _returnMorningController,
              decoration: const InputDecoration(
                  labelText: 'Retorno manhã',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _leaveAfternoonController,
              decoration: const InputDecoration(
                  labelText: 'Saída tarde',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _returnAfternoonController,
              decoration: const InputDecoration(
                  labelText: 'Retorno tarde',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _leaveNightController,
              decoration: const InputDecoration(
                  labelText: 'Saída noite',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _returnNightController,
              decoration: const InputDecoration(
                  labelText: 'Retorno noite',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _quantityOfBusController,
              decoration: const InputDecoration(
                  labelText: 'Quantidade de ônibus',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
              validator: (value) =>
                  value!.isEmpty ? 'Informe a quantidade de ônibus' : null,
              onSaved: (value) {
                qtd = int.tryParse(value ?? '1')!;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _kilometerOfBusController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+(,\d{0,2})?$')),
              ],
              decoration: InputDecoration(
                  labelText: 'Quilometragem',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
              onSaved: (value) {
                final formattedValue = value?.replaceAll(',', '.');
                km = double.tryParse(formattedValue ?? '')!;
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
              controller: _teachersController,
              decoration: const InputDecoration(
                  labelText: 'Professores',
                  hintText: 'ex: Maria, João, etc.',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
              validator: Validatorless.required('Informe os professores'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: AppUiConfig.elevatedButtonThemeCustom,
              onPressed: () {
                _saveForm(context);
              },
              child: const Text(
                'Salvar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _saveForm(BuildContext context) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      _formKey.currentState?.save();
      final activity = ExtracurricularActivity(
        schoolId: school.id!,
        contract: _contract,
        memo: _memoController.text,
        tcbCode: '0000',
        local: 'Local',
        dateOfCreate: DateTime.now(),
        driverPhone: '0000',
        busDriver: 'Motorista',
        busPlate: 'AAA-0000',
        monitorsId: [],
        students: [],
        isDone: false,
        dateOfEvent: _dateOfEvent,
        title: _titleController.text,
        setOfThemes: _setOfThemesController.text,
        skillsToDevelop: _skillsToDevelopController.text,
        subject: subject,
        leaveMorning: _leaveoMorningController.text,
        returnMorning: _returnMorningController.text,
        leaveAfternoon: _leaveAfternoonController.text,
        returnAfternoon: _returnAfternoonController.text,
        leaveNight: _leaveNightController.text,
        returnNight: _returnNightController.text,
        quantityOfBus: qtd,
        kilometerOfBus: km,
        teachers: _teachersController.text,
      );
      Provider.of<ECActivityProvider>(context, listen: false)
          .createECActivity(ecActivity: activity);
      Navigator.of(context).pop();
    }
  }
}
