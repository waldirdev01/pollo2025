import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/e_c_student.dart';
import 'package:pollo2025/app/modules/extracurricular_activity/students_ec/widget/ec_student_card.dart';
import 'package:pollo2025/app/providers/e_c_activity_provider.dart';
import 'package:pollo2025/app/providers/e_c_student_provider.dart';

import '../../../core/ui/ap_ui_config.dart';
import '../../../models/extracurricular_activity.dart';

class ECStudentsListBySchool extends StatefulWidget {
  const ECStudentsListBySchool({super.key, required this.ecActivity});
  final ExtracurricularActivity ecActivity;

  @override
  State<ECStudentsListBySchool> createState() => _ECStudentsListBySchoolState();
}

class _ECStudentsListBySchoolState extends State<ECStudentsListBySchool> {
  List<ECStudent> studentsList = [];
  List<ECStudent> filteredStudents = [];
  Map<String, bool> selectedStudents = {};
  Future<List<ECStudent>> _getStudentsBySchoolId(String schoolId) async {
    return await context
        .read<ECStudentProvider>()
        .getECStudentsBySchool(schoolId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Selecionar alunos para evento',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<List<ECStudent>>(
                  initialData: const [],
                  future: _getStudentsBySchoolId(widget.ecActivity.schoolId),
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
                          final students = snapshot.data!;
                          students.sort((a, b) => a.name.compareTo(b.name));
                          for (var student in widget.ecActivity.students) {
                            selectedStudents.putIfAbsent(
                                student.id!, () => true);
                          }

                          for (var student in students) {
                            selectedStudents.putIfAbsent(
                                student.id!, () => false);
                          }
                          return ListView.builder(
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              final student = students[index];
                              return ECStudentCard(
                                student: student,
                                checkBox: Checkbox(
                                  value: selectedStudents[student.id],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      selectedStudents[student.id!] = value!;
                                      // Atualiza a lista de estudantes filtrados com base na seleção
                                      if (value) {
                                        filteredStudents.add(student);
                                      } else {
                                        filteredStudents.removeWhere(
                                            (s) => s.id == student.id);
                                        widget.ecActivity.students.removeWhere(
                                            (s) => s.id == student.id);
                                      }
                                    });
                                  },
                                ),
                                value: selectedStudents[student.id]!,
                                deleteFunction: () =>
                                    deleteFunction(student.id!),
                              );
                            },
                          );
                        }
                    }
                  },
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppUiConfig.themeCustom.primaryColor,
        onPressed: () {
          // Processa apenas os estudantes selecionados
          for (var student in filteredStudents) {
            widget.ecActivity.students.add(student);
          }
          context
              .read<ECActivityProvider>()
              .updateECActivity(widget.ecActivity);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }

  deleteFunction(String id) {
    setState(() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Excluir aluno'),
              content: const Text(
                  'Deseja excluir o aluno? Esta ação não poderá ser desfeita.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<ECStudentProvider>().deleteECStudent(id);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Excluir'),
                ),
              ],
            );
          });
    });
  }
}
