// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/modules/student/widgets/student_card.dart';

import '../../models/student.dart';
import '../../providers/student_provider.dart';
import 'student_details_page.dart';

class StudentsByName extends StatefulWidget {
  const StudentsByName({super.key});

  @override
  _StudentsByNameState createState() => _StudentsByNameState();
}

class _StudentsByNameState extends State<StudentsByName> {
  final _nameFilterController = TextEditingController();
  List<Student> filteredStudents = [];

  Future<List<Student>>? loadStudents;

  Future<List<Student>> _getStudents(String name) async {
    final studentsList =
        await context.read<StudentProvider>().getStudentByName(name);
    return studentsList;
  }

  @override
  void dispose() {
    _nameFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Alunos por nome',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Flexible(
                    child: TextField(
                      controller: _nameFilterController,
                      decoration: const InputDecoration(
                        labelText: 'Buscar por nome',
                      ),
                      onSubmitted: (value) {
                        _nameFilterController.text = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: AppUiConfig.elevatedButtonThemeCustom,
                    onPressed: () {
                      final students = _getStudents(
                          _nameFilterController.text.toUpperCase());
                      setState(() {
                        loadStudents = Future.value(students);
                      });
                    },
                    child: const Text('Filtrar',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.9,
                child: FutureBuilder<List<Student>>(
                  initialData: const [],
                  future: loadStudents ?? Future.value([]),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const Text('Nenhum estado de conexão.');
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text('Erro: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return const Text('Nenhum dado disponível.');
                        } else {
                          final students = snapshot.data;
                          return ListView.builder(
                            itemCount: students!.length,
                            itemBuilder: (context, index) {
                              final student = students[index];

                              return InkWell(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StudentDetailsPage(
                                                  student: student))),
                                  child: StudentCard(student: student));
                            },
                          );
                        }
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
