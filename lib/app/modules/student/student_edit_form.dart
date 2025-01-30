import 'package:flutter/material.dart';
import 'package:pollo2025/app/models/app_user.dart';
import 'package:pollo2025/app/models/student.dart';
import 'package:pollo2025/app/providers/app_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/ui/ap_ui_config.dart';
import '../../core/widgets/app_field.dart';
import '../../models/pne.dart';
import '../../providers/student_provider.dart';

class StudentEditForm extends StatefulWidget {
  const StudentEditForm({super.key});

  @override
  State<StudentEditForm> createState() => _StudentEditFormState();
}

class _StudentEditFormState extends State<StudentEditForm> {
  final _formKey = GlobalKey<FormState>();

  String _level = 'FUNDAMENTAL';
  PneType _pneType = PneType.none;
  bool _isLoading = false;
  String _requiresGuardian = 'NÃO';
  String _pneTypeDescription(PneType type) {
    switch (type) {
      case PneType.visualImpairment:
        return 'Deficiente Visual';
      case PneType.wheelchairUser:
        return 'Cadeirante';
      case PneType.autistic:
        return 'Autista';
      case PneType.other:
        return 'Outros';
      case PneType.none:
        return 'Nenhum';
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = ModalRoute.of(context)!.settings.arguments as Student;
    _level = student.level;
    _pneType = student.pne.type;
    final appUser = context.read<AppAuthProvider>().appUser;
    _requiresGuardian = student.requiresGuardian ? 'SIM' : 'NÃO';
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Registrar Aluno'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              appUser?.type == UserType.monitor
                  ? SizedBox.shrink()
                  : AppField(
                      initialValue: student.name,
                      keyBoadType: TextInputType.text,
                      label: 'Nome',
                      validator:
                          Validatorless.required('Por favor, insira o nome'),
                      onSaved: (value) => student.name = value!.toUpperCase(),
                    ),
              const SizedBox(height: 10),
              AppField(
                initialValue: student.ieducar,
                keyBoadType: TextInputType.number,
                label: 'I-educar',
                validator: Validatorless.required(
                    'Por favor, insira o código Ieducar'),
                onSaved: (value) => student.ieducar = value!,
              ),
              const SizedBox(height: 10),
              appUser?.type == UserType.monitor
                  ? const SizedBox.shrink()
                  : AppField(
                      initialValue: student.cpf,
                      keyBoadType: TextInputType.number,
                      label: 'CPF',
                      validator: Validatorless.cpf('CPF inválido'),
                      onSaved: (value) => student.cpf = value!,
                    ),
              const SizedBox(height: 10),
              AppField(
                  initialValue: student.classroomGrade,
                  label: 'Turma',
                  validator:
                      Validatorless.required('Por favor, insira a turma'),
                  onSaved: (value) => student.classroomGrade = value!),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: InputDecoration(
                    labelText: 'Mod. Ensino',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                value: _level,
                onChanged: (newValue) {
                  setState(() {
                    _level = newValue as String;
                    student.level = _level;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: 'FUNDAMENTAL',
                    child: Text('FUNDAMENTAL'),
                  ),
                  DropdownMenuItem(
                    value: 'INFANTIL',
                    child: Text('INFANTIL'),
                  ),
                  DropdownMenuItem(
                    value: 'MÉDIO',
                    child: Text('MÉDIO'),
                  ),
                  DropdownMenuItem(
                    value: 'INTEGRAL',
                    child: Text('INTEGRAL'),
                  ),
                  DropdownMenuItem(
                    value: 'EJA',
                    child: Text('EJA'),
                  ),
                  DropdownMenuItem(
                    value: 'ESPECIAL',
                    child: Text('ESPECIAL'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<PneType>(
                decoration: InputDecoration(
                  labelText: 'PNE',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                value: _pneType,
                onChanged: (newValue) {
                  setState(() {
                    _pneType = newValue!;
                    student.pne =
                        PNE(type: _pneType); // Atualiza o PNE do estudante
                  });
                },
                items: PneType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_pneTypeDescription(
                        type)), // Utilize a mesma função auxiliar do formulário de criação
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                  value: student.residenceType,
                  decoration: InputDecoration(
                    labelText: 'Tipo de Residência',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'URBANA', child: Text('URBANA')),
                    DropdownMenuItem(value: 'RURAL', child: Text('RURAL'))
                  ],
                  onChanged: (newValue) {
                    student.residenceType = newValue as String;
                  }),
              appUser?.type == UserType.admin
                  ? const SizedBox(height: 10)
                  : const SizedBox.shrink(),
              appUser?.type == UserType.admin
                  ? AppField(
                      initialValue: student.differentiated,
                      keyBoadType: TextInputType.text,
                      label: 'Diferenciado (guarda compartilhada, etc)',
                      onSaved: (value) => student.differentiated = value!,
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 10),
              appUser?.type == UserType.admin
                  ? DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Necessita de acompanhante?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      value: _requiresGuardian,
                      onChanged: (newValue) {
                        setState(() {
                          _requiresGuardian = newValue as String;
                          student.requiresGuardian =
                              _requiresGuardian == 'SIM' ? true : false;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'SIM',
                          child: Text('SIM'),
                        ),
                        DropdownMenuItem(
                          value: 'NÃO',
                          child: Text('NÃO'),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: AppUiConfig.elevatedButtonThemeCustom,
                  onPressed: _isLoading == true
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            _formKey.currentState!.save();

                            context
                                .read<StudentProvider>()
                                .updateStudent(student);

                            Navigator.pop(context, student);
                          }
                        },
                  child: const Text(
                    'Alterar dados do aluno',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
