// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/providers/student_provider.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/widgets/app_field.dart';
import '../../models/pne.dart';
import '../../models/school.dart';
import '../../models/student.dart';

class StudentCreateForm extends StatefulWidget {
  const StudentCreateForm({super.key});

  @override
  State<StudentCreateForm> createState() => _StudentCreateFormState();
}

class _StudentCreateFormState extends State<StudentCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _ieducarEC = TextEditingController();
  final _classroomGradeEC = TextEditingController();
  final _cpfEC = TextEditingController();
  //bool hasImage = false;
  String _level = 'FUNDAMENTAL';
  PneType _pneType = PneType.none;
  String _residenceType = 'URBANA';
  bool _isLoading = false;
  String requiresGuardian = 'NÃO';

  String imageUrl = '';
/*
  Future<void> _pickImage(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: imageSource);
    setState(() {
      _isLoading = true;
    });
    if (image != null) {
      // Procede com o upload do arquivo
      imageUrl = await _uploadImageToFirebase(image);
      setState(() {
        hasImage = true;
        _isLoading = false;
      });
    }
  }

  Future<String> _uploadImageToFirebase(XFile image) async {
    String fileName = 'students/${DateTime.now().millisecondsSinceEpoch}.png';
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(fileName);

    // Ler o arquivo como bytes
    final bytes = await image.readAsBytes();

    // Fazendo o upload dos bytes
    firebase_storage.UploadTask uploadTask = ref.putData(
        bytes, firebase_storage.SettableMetadata(contentType: 'image/png'));

    // Aguarda até o upload estar completo
    await uploadTask;

    // Retorna a URL da imagem
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }
*/

  @override
  void dispose() {
    _nameEC.dispose();
    _ieducarEC.dispose();
    _classroomGradeEC.dispose();
    _cpfEC.dispose();
    super.dispose();
  }

  cleanControllers() {
    setState(() {
      _nameEC.clear();
      _ieducarEC.clear();
      _classroomGradeEC.clear();
      _cpfEC.clear();
      _isLoading = false;
    });
  }

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
    final school = ModalRoute.of(context)!.settings.arguments as School;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Registrar Aluno'),
      ),
      body: /* !hasImage
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.file_upload,
                    size: 100,
                    color: _isLoading
                        ? Colors.grey
                        : AppUiConfig.themeCustom.primaryColor,
                  ),
                  const SizedBox(height: 10),
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        )
                      : ElevatedButton(
                          style: AppUiConfig.elevatedButtonThemeCustom,
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Escolha uma opção'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.camera_alt),
                                        title: const Text('Câmera'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _pickImage(ImageSource.camera);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.image),
                                        title: const Text('Galeria'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _pickImage(ImageSource.gallery);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          child: const Text(
                            'Adicionar Termo',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                ],
              ),
            )
          : */
          SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
              AppField(
                keyBoadType: TextInputType.number,
                controller: _cpfEC,
                label: 'CPF',
                validator: Validatorless.cpf('CPF inválido'),
              ),
              const SizedBox(height: 10),
              AppField(
                  label: 'Série/Turma',
                  controller: _classroomGradeEC,
                  validator: Validatorless.required(
                      'Por favor, insira a série e turma')),
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
              DropdownButtonFormField(
                decoration: InputDecoration(
                    labelText: 'Tipo de Residência',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                value: _residenceType,
                onChanged: (newValue) {
                  setState(() {
                    _residenceType = newValue as String;
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
                  });
                },
                items: PneType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_pneTypeDescription(type)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Necessita de acompanhante?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                value: requiresGuardian,
                onChanged: (newValue) {
                  setState(() {
                    requiresGuardian = newValue as String;
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
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  style: AppUiConfig.elevatedButtonThemeCustom,
                  onPressed: _isLoading == true
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            _formKey.currentState!.save();

                            final student = Student(
                                name: _nameEC.text.toUpperCase(),
                                imageUrl: imageUrl,
                                ieducar: _ieducarEC.text,
                                level: _level,
                                schoolId: school.id!,
                                cpf: _cpfEC.text,
                                itineraryId: '',
                                requiresGuardian:
                                    requiresGuardian == 'SIM' ? true : false,
                                pne: PNE(type: _pneType),
                                residenceType: _residenceType,
                                authorized: false,
                                classroomGrade: _classroomGradeEC.text,
                                attendance: [],
                                createdAt: DateTime.now(),
                                incidentsId: []);
                            await context
                                .read<StudentProvider>()
                                .createStudent(student: student);
                            school.studentsId?.add(student.id!);
                            cleanControllers();
                            // hasImage = false;
                            Navigator.pop(context);
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Registrar Aluno',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
