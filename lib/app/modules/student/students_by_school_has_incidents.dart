import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/modules/student/student_details_page.dart';
import 'package:pollo2025/app/providers/student_provider.dart';

import '../../models/itinerary.dart';
import '../../models/school.dart';
import '../../models/student.dart';

class StudentsBySchoolHasIncidents extends StatefulWidget {
  const StudentsBySchoolHasIncidents(
      {super.key, required this.school, this.itinerary});
  final School school;
  final Itinerary? itinerary;

  @override
  State<StudentsBySchoolHasIncidents> createState() =>
      _StudentsBySchoolHasIncidentsState();
}

class _StudentsBySchoolHasIncidentsState
    extends State<StudentsBySchoolHasIncidents> {
  List<Student> filteredStudents = [];
  bool selected = false;

  Future<List<Student>>? loadStudents;

  Future<List<Student>> _getStudents() async {
    final students = await context
        .read<StudentProvider>()
        .getStudentsBySchoolHaveIncident(widget.school.id!);
    return students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Alunos da Escola ${widget.school.name}',
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: FutureBuilder<List<Student>>(
              initialData: const [],
              future: _getStudents(),
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
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('Nenhum aluno encontrado.'));
                      }
                      final students = snapshot.data;
                      return ListView.builder(
                        itemCount: students!.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          return Card(
                            margin: const EdgeInsets.all(8),
                            color: getColorByAbsences(student.countAbsences()),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        student.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        'CPF: ${student.cpf}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'Faltas: ${student.countAbsences()}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                student.incidentsId.isEmpty
                                    ? const SizedBox.shrink()
                                    : TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StudentDetailsPage(
                                                student: student,
                                              ),
                                            ),
                                          );
                                        },
                                        child:
                                            const Text('Verificar incidente'))
                              ],
                            ),
                          );
                        },
                      );
                    }
                }
              },
            )),
      ),
    );
  }

  getColorByAbsences(int absences) {
    if (absences < 10) {
      return Colors.white;
    } else if (absences >= 10 && absences < 20) {
      return Colors.yellow;
    } else if (absences >= 20 && absences < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
