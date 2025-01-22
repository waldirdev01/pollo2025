import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/models/extracurricular_activity.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../models/app_user.dart';
import '../../../providers/app_auth_provider.dart';
import '../../../providers/e_c_activity_provider.dart';

class ECEditForm extends StatefulWidget {
  const ECEditForm({super.key});

  @override
  State<ECEditForm> createState() => _ECEditFormState();
}

class _ECEditFormState extends State<ECEditForm> {
  String _contract = 'CONTRACT';
  final _formKey = GlobalKey<FormState>();
  DateTime _dateOfEvent = DateTime.now();
  late ExtracurricularActivity ecActivity;
  Subject subject = Subject.art;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _dateOfEvent = ecActivity.dateOfEvent;
      });
    });
  }

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
  Widget build(BuildContext context) {
    final appUser = context.read<AppAuthProvider>().appUser;
    ecActivity =
        ModalRoute.of(context)!.settings.arguments as ExtracurricularActivity;
    subject = ecActivity.subject;
    _contract = ecActivity.contract;
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Editar atividade',
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: appUser?.type == UserType.schoolMember
                    ? _schoolMemberForm(context)
                    : appUser?.type == UserType.coordinator
                        ? _coordinatorForm(context)
                        : _adminForm(context),
              )),
        ));
  }

  Column _adminForm(BuildContext context) {
    return Column(
      children: [
        Text(DateFormat('dd/MM/yyyy').format(_dateOfEvent)),
        TextButton(
          onPressed: () => _selectDateOfEvent(context),
          child: const Text('Selecionar data do evento'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.title,
          decoration: const InputDecoration(
              labelText: 'Temática',
              hintText: 'ex: Arte Circense',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )),
          validator: Validatorless.required('Informe a temática'),
          onSaved: (value) => ecActivity.title = value!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.local,
          decoration: const InputDecoration(
              labelText: 'Local',
              hintText: 'Nome do local e/ou endereço',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.local = newValue!,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe um local';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.setOfThemes,
          decoration: const InputDecoration(
              labelText: 'Conteúdos e habilidades do currículo',
              hintText: 'ex: Arte e cultura, corpo e movimento, etc.',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.setOfThemes = newValue!,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe um conjunto de temas';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.skillsToDevelop,
          decoration: const InputDecoration(
              labelText: 'Possíveis habilidades desenvolvidas após a atividade',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.skillsToDevelop = newValue!,
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
              ecActivity.subject = newValue!;
            });
          },
          items: Subject.values
              .map((Subject subject) => DropdownMenuItem<Subject>(
                    value: subject,
                    child: Text(subject.name.toString()),
                  ))
              .toList(),
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.leaveMorning,
          decoration: const InputDecoration(
              labelText: 'Saída manhã',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.leaveMorning = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.returnMorning,
          decoration: const InputDecoration(
              labelText: 'Retorno manhã',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.returnMorning = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.leaveAfternoon,
          decoration: const InputDecoration(
              labelText: 'Saída tarde',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.leaveAfternoon = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: ecActivity.returnAfternoon,
          decoration: const InputDecoration(
              labelText: 'Retorno tarde',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.returnAfternoon = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.leaveNight,
          decoration: const InputDecoration(
              labelText: 'Saída noite',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.leaveNight = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.returnNight,
          decoration: const InputDecoration(
              labelText: 'Retorno noite',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.returnNight = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.quantityOfBus.toString(),
          decoration: InputDecoration(
              labelText: 'Quantidade de ônibus',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          onSaved: (value) {
            ecActivity.quantityOfBus = int.tryParse(value ?? '')!;
          },
          validator: Validatorless.required('Informe a quantidade de ônibus'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.kilometerOfBus.toString(),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+(,\d{0,2})?$')),
          ],
          decoration: InputDecoration(
              labelText: 'Quilometragem por ônibus',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          onSaved: (value) {
            final formattedValue = value?.replaceAll(',', '.');
            ecActivity.kilometerOfBus = double.tryParse(formattedValue ?? '')!;
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
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.busPlate,
          decoration: const InputDecoration(
              labelText: 'Placa dos veículos',
              hintText: 'JJJ-1234, AAA-1234',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )),
          onSaved: (value) => ecActivity.busPlate = value!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.busDriver,
          decoration: const InputDecoration(
              labelText: 'Nomes dos motoristas',
              hintText: 'João, Maria',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )),
          onSaved: (value) => ecActivity.busDriver = value!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.driverPhone,
          decoration: const InputDecoration(
              labelText: 'Telefones dos motoristas',
              hintText: '99999-9999, 88888-8888',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )),
          onSaved: (value) => ecActivity.driverPhone = value!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.tcbCode,
          decoration: const InputDecoration(
              labelText: 'Código TCB',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )),
          onSaved: (value) => ecActivity.tcbCode = value!,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField(
          decoration: InputDecoration(
              labelText: 'Contrato',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          value: _contract,
          onChanged: (newValue) {
            setState(() {
              _contract = newValue as String;
              ecActivity.contract = _contract;
            });
          },
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
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.teachers,
          decoration: const InputDecoration(
              labelText: 'Professores',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )),
          onSaved: (value) => ecActivity.teachers = value!,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: AppUiConfig.elevatedButtonThemeCustom,
          onPressed: () {
            Navigator.of(context).pushNamed(
                Constants.kUSERMONITORASFORECLISTROUTE,
                arguments: ecActivity);
          },
          child: const Text('Selecionar Monitora',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: AppUiConfig.elevatedButtonThemeCustom,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              ecActivity.dateOfEvent = _dateOfEvent;
              ecActivity.subject = subject;
              context.read<ECActivityProvider>().updateECActivity(ecActivity);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Editar Atividade',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ],
    );
  }

  Column _coordinatorForm(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.leaveMorning,
          decoration: const InputDecoration(
              labelText: 'Saída manhã',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.leaveMorning = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.returnMorning,
          decoration: const InputDecoration(
              labelText: 'Retorno manhã',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.returnMorning = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.leaveAfternoon,
          decoration: const InputDecoration(
              labelText: 'Saída tarde',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.leaveAfternoon = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: ecActivity.returnAfternoon,
          decoration: const InputDecoration(
              labelText: 'Retorno tarde',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.returnAfternoon = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.leaveNight,
          decoration: const InputDecoration(
              labelText: 'Saída noite',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.leaveNight = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.returnNight,
          decoration: const InputDecoration(
              labelText: 'Retorno noite',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.returnNight = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.quantityOfBus.toString(),
          decoration: InputDecoration(
              labelText: 'Quantidade de ônibus',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          onSaved: (value) {
            ecActivity.quantityOfBus = int.tryParse(value ?? '')!;
          },
          validator: Validatorless.required('Informe a quantidade de ônibus'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.kilometerOfBus.toString(),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+(,\d{0,2})?$')),
          ],
          decoration: InputDecoration(
              labelText: 'Quilometragem por ônibus',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          onSaved: (value) {
            final formattedValue = value?.replaceAll(',', '.');
            ecActivity.kilometerOfBus = double.tryParse(formattedValue ?? '')!;
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
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.busPlate,
          decoration: const InputDecoration(
              labelText: 'Placas dos veículos',
              hintText: 'JJJ-1234, AAA-1234',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )),
          onSaved: (value) => ecActivity.busPlate = value!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.busDriver,
          decoration: const InputDecoration(
              labelText: 'Nomes dos motoristas',
              hintText: 'João, Maria',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )),
          onSaved: (value) => ecActivity.busDriver = value!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.driverPhone,
          decoration: const InputDecoration(
              labelText: 'Telefones dos motoristas',
              hintText: '99999-9999, 88888-8888',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )),
          onSaved: (value) => ecActivity.driverPhone = value!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.tcbCode,
          decoration: const InputDecoration(
              labelText: 'Código TCB',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )),
          onSaved: (value) => ecActivity.tcbCode = value!,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: AppUiConfig.elevatedButtonThemeCustom,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              ecActivity.dateOfEvent = _dateOfEvent;
              ecActivity.subject = subject;
              context.read<ECActivityProvider>().updateECActivity(ecActivity);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Editar Atividade',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ],
    );
  }

  Column _schoolMemberForm(BuildContext context) {
    return Column(
      children: [
        Text(DateFormat('dd/MM/yyyy').format(_dateOfEvent)),
        TextButton(
          onPressed: () => _selectDateOfEvent(context),
          child: const Text('Selecionar data do evento'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.memo,
          decoration: const InputDecoration(
              labelText: 'Memorando',
              hintText: 'ex: Memorando 45/2024',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )),
          onSaved: (value) => ecActivity.title = value!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.title,
          decoration: const InputDecoration(
              labelText: 'Temática',
              hintText: 'ex: Arte Circense',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )),
          validator: Validatorless.required('Informe a temática'),
          onSaved: (value) => ecActivity.title = value!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.local,
          decoration: const InputDecoration(
              labelText: 'Local',
              hintText: 'Nome do local e/ou endereço',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.local = newValue!,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe um local';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.setOfThemes,
          decoration: const InputDecoration(
              labelText: 'Conteúdos e habilidades do currículo',
              hintText: 'ex: Arte e cultura, corpo e movimento, etc.',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.setOfThemes = newValue!,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe um conjunto de temas';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.skillsToDevelop,
          decoration: const InputDecoration(
              labelText: 'Possíveis habilidades desenvolvidas após a atividade',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.skillsToDevelop = newValue!,
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
              ecActivity.subject = newValue!;
            });
          },
          items: Subject.values
              .map((Subject subject) => DropdownMenuItem<Subject>(
                    value: subject,
                    child: Text(subject.name.toString()),
                  ))
              .toList(),
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.leaveMorning,
          decoration: const InputDecoration(
              labelText: 'Saída manhã',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.leaveMorning = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.returnMorning,
          decoration: const InputDecoration(
              labelText: 'Retorno manhã',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.returnMorning = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.leaveAfternoon,
          decoration: const InputDecoration(
              labelText: 'Saída tarde',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.leaveAfternoon = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: ecActivity.returnAfternoon,
          decoration: const InputDecoration(
              labelText: 'Retorno tarde',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.returnAfternoon = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.leaveNight,
          decoration: const InputDecoration(
              labelText: 'Saída noite',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.leaveNight = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.returnNight,
          decoration: const InputDecoration(
              labelText: 'Retorno noite',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
          onSaved: (newValue) => ecActivity.returnNight = newValue!,
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.quantityOfBus.toString(),
          decoration: InputDecoration(
              labelText: 'Quantidade de ônibus',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          onSaved: (value) {
            ecActivity.quantityOfBus = int.tryParse(value ?? '')!;
          },
          validator: Validatorless.required('Informe a quantidade de ônibus'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.kilometerOfBus.toString(),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+(,\d{0,2})?$')),
          ],
          decoration: InputDecoration(
              labelText: 'Quilometragem por ônibus',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          onSaved: (value) {
            final formattedValue = value?.replaceAll(',', '.');
            ecActivity.kilometerOfBus = double.tryParse(formattedValue ?? '')!;
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
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          initialValue: ecActivity.teachers,
          decoration: const InputDecoration(
              labelText: 'Professores',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              )),
          onSaved: (value) => ecActivity.teachers = value!,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: AppUiConfig.elevatedButtonThemeCustom,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              ecActivity.dateOfEvent = _dateOfEvent;
              ecActivity.subject = subject;
              context.read<ECActivityProvider>().updateECActivity(ecActivity);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Editar Atividade',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ],
    );
  }
}
