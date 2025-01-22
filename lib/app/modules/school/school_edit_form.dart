import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/modules/school/widgets/school_text_form_field_edit.dart';
import 'package:pollo2025/app/providers/school_provider.dart';

import '../../core/ui/messages.dart';
import '../../models/school.dart';

class SchoolEditForm extends StatefulWidget {
  const SchoolEditForm({super.key});

  @override
  State<SchoolEditForm> createState() => _SchoolEditFormState();
}

class _SchoolEditFormState extends State<SchoolEditForm> {
  final _formKey = GlobalKey<FormState>();
  String typeSchool = 'URBANA';
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final school = ModalRoute.of(context)!.settings.arguments as School;
    typeSchool = school.type;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Escola'),
          iconTheme: AppUiConfig.iconThemeCustom(),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SchoolTextFormFieldEdit(
                  labelText: 'Nome da escola',
                  initialValue: school.name,
                  onSaved: (value) => school.name = value!,
                ),
                SchoolTextFormFieldEdit(
                  labelText: 'Telefone',
                  initialValue: school.phone,
                  onSaved: (value) => school.phone = value!,
                ),
                SchoolTextFormFieldEdit(
                  labelText: 'Diretor(a)',
                  initialValue: school.principalName,
                  onSaved: (value) => school.principalName = value!,
                ),
                SchoolTextFormFieldEdit(
                  labelText: 'Matrícula do(a) diretor(a)',
                  initialValue: school.principalRegister,
                  onSaved: (value) => school.principalRegister = value!,
                ),
                SchoolTextFormFieldEdit(
                  labelText: 'Nome do(a) secretário(a) escolar',
                  initialValue: school.secretaryName,
                  onSaved: (value) => school.secretaryName = value!,
                ),
                SchoolTextFormFieldEdit(
                  labelText: 'Matrícula do(a) secretário(a) escolar',
                  initialValue: school.secretaryRegister,
                  onSaved: (value) => school.secretaryRegister = value!,
                ),
                SchoolTextFormFieldEdit(
                  labelText: 'Endereço',
                  initialValue: school.inep,
                  onSaved: (value) => school.inep = value!,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Tipo de escola',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'URBANA',
                      child: Text('URBANA'),
                    ),
                    DropdownMenuItem(
                      value: 'RURAL',
                      child: Text('RURAL'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      typeSchool = value as String;
                      school.type = typeSchool;
                    });
                  },
                  value: typeSchool,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: AppUiConfig.elevatedButtonThemeCustom,
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            context.read<SchoolProvider>().updateSchool(school);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Messages.of(context)
                                .showInfo('Escola atualizada com sucesso');
                          }
                        },
                  child: const Text('Salvar',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ],
            ),
          ),
        ));
  }
}
