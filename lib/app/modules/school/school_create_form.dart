// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/ui/messages.dart';
import '../../core/widgets/app_field.dart';
import '../../models/school.dart';
import '../../providers/school_provider.dart';

class SchoolCreateForm extends StatefulWidget {
  const SchoolCreateForm({super.key});

  @override
  _SchoolCreateFormState createState() => _SchoolCreateFormState();
}

class _SchoolCreateFormState extends State<SchoolCreateForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _nameEC = TextEditingController();
  final _phoneEC = TextEditingController();
  final _inepEC = TextEditingController();
  final _principalNameEC = TextEditingController();
  final _principalRegisterEC = TextEditingController();
  final _secretaryNameEC = TextEditingController();
  final _secretaryRegisterEC = TextEditingController();
  String _typeSchool = 'URBANA';

  @override
  void dispose() {
    _nameEC.dispose();
    _phoneEC.dispose();
    _inepEC.dispose();
    _principalNameEC.dispose();
    _principalRegisterEC.dispose();
    _secretaryNameEC.dispose();
    _secretaryRegisterEC.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (formValid) {
      try {
        final school = School(
          name: _nameEC.text,
          phone: _phoneEC.text,
          inep: _inepEC.text,
          principalName: _principalNameEC.text,
          principalRegister: _principalRegisterEC.text,
          secretaryName: _secretaryNameEC.text,
          secretaryRegister: _secretaryRegisterEC.text,
          type: _typeSchool,
        );
        setState(() {
          _isLoading = true;
        });
        await context.read<SchoolProvider>().createSchool(school: school);
        Messages.of(context).showInfo('Escola criada com sucesso');
      } on FirebaseException catch (e) {
        Messages.of(context).showError('Erro ao criar escola $e');
      } finally {
        setState(() {
          _isLoading = false;
        });

        setState(() {
          _inepEC.clear();
          _nameEC.clear();
          _phoneEC.clear();
          _principalNameEC.clear();
          _principalRegisterEC.clear();
          _secretaryNameEC.clear();
          _secretaryRegisterEC.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Escola'),
        iconTheme: AppUiConfig.iconThemeCustom(),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppField(
                label: 'nome',
                controller: _nameEC,
                validator: Validatorless.required('O nome é obrigatório'),
              ),
              const SizedBox(
                height: 10,
              ),
              AppField(
                label: 'telefone',
                controller: _phoneEC,
                validator: Validatorless.required('O telefone é obrigatório'),
              ),
              const SizedBox(
                height: 10,
              ),
              AppField(
                label: 'inep',
                controller: _inepEC,
                validator: Validatorless.required('O inep é obrigatório'),
              ),
              const SizedBox(
                height: 10,
              ),
              AppField(
                label: 'nome do(a) diretor(a)',
                controller: _principalNameEC,
                validator: Validatorless.required(
                    'O nome do(a) diretor(a) é obrigatório'),
              ),
              const SizedBox(
                height: 10,
              ),
              AppField(
                label: 'matrícula do(a) diretor(a)',
                controller: _principalRegisterEC,
                validator:
                    Validatorless.required('A matrícula do(a) é obrigatória'),
              ),
              const SizedBox(
                height: 10,
              ),
              AppField(
                label: 'nome do(a) secretário(a)',
                controller: _secretaryNameEC,
                validator: Validatorless.required(
                    'O nome do(a) secretário(a) é obrigatório'),
              ),
              const SizedBox(
                height: 10,
              ),
              AppField(
                label: 'matrícula do(a) secretário(a)',
                controller: _secretaryRegisterEC,
                validator: Validatorless.required(
                    'A matrícula do(a) secretário(a) é obrigatória'),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Tipo de escola',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                value: _typeSchool,
                onChanged: (value) {
                  setState(() {
                    _typeSchool = value!;
                  });
                },
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
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: AppUiConfig.elevatedButtonThemeCustom,
                onPressed: _isLoading ? null : _submitForm,
                child: const Text('Adicionar Escola',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
