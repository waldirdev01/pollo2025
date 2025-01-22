import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/providers/e_c_student_provider.dart';
import 'package:validatorless/validatorless.dart';
import '../../../core/widgets/app_field.dart';
import '../../../models/e_c_student.dart';

class ECStudentCreateForm extends StatefulWidget {
  const ECStudentCreateForm({super.key});

  @override
  State<ECStudentCreateForm> createState() => _ECStudentCreateFormState();
}

class _ECStudentCreateFormState extends State<ECStudentCreateForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameEC = TextEditingController();
  final TextEditingController _ieducarEC = TextEditingController();
  late String schoolId;
  String _level = 'FUNDAMENTAL';
  String _typeResidence = 'URBANA';
  @override
  Widget build(BuildContext context) {
    final schoolIdLoad = ModalRoute.of(context)!.settings.arguments as String;
    schoolId = schoolIdLoad;
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Cadastro de Aluno',
        ),
        body: Padding(
          padding: const EdgeInsets.all(4),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppField(
                  keyBoadType: TextInputType.text,
                  controller: _nameEC,
                  label: 'Nome',
                  validator: Validatorless.required('Por favor, insira o nome'),
                ),
                const SizedBox(height: 10),
                AppField(
                  keyBoadType: TextInputType.number,
                  controller: _ieducarEC,
                  label: 'I-educar',
                  validator: Validatorless.required(
                      'Por favor, insira o código Ieducar'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _level,
                  decoration: InputDecoration(
                    labelText: 'Mod. de Ensino',
                    labelStyle: const TextStyle(fontSize: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  items: <String>[
                    'FUNDAMENTAL',
                    'INFANTIL',
                    'ESPECIAL',
                    'EJA',
                    'INTEGRAL',
                    'MÉDIO',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 18)),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _level = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _typeResidence,
                  decoration: InputDecoration(
                    labelText: 'Tipo de Residência',
                    labelStyle: const TextStyle(fontSize: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  items: <String>['URBANA', 'RURAL']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 18)),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _typeResidence = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: AppUiConfig.elevatedButtonThemeCustom,
                  onPressed: _submitForm,
                  child: const Text('Salvar',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                )
              ],
            ),
          ),
        ));
  }

  _submitForm() {
    if (_formKey.currentState!.validate()) {
      final ecStudent = ECStudent(
        name: _nameEC.text.toUpperCase(),
        ieducarCode: _ieducarEC.text,
        schoolId: schoolId,
        level: _level,
        typeResidence: _typeResidence,
      );
      context.read<ECStudentProvider>().createECStudent(ecStudent: ecStudent);
      setState(() {
        _nameEC.clear();
        _ieducarEC.clear();
      });
    }
  }
}
