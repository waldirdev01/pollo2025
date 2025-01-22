import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/app_user.dart';
import 'package:pollo2025/app/providers/app_auth_provider.dart';
import 'package:pollo2025/app/providers/itinerary_provider.dart';
import 'package:pollo2025/app/providers/student_provider.dart';
import '../../models/itinerary.dart';
import '../../models/school.dart';
import '../../models/student.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class StudentsAddItineraryForSchoollList extends StatefulWidget {
  const StudentsAddItineraryForSchoollList(
      {super.key, required this.school, this.itinerary});
  final School school;
  final Itinerary? itinerary;

  @override
  State<StudentsAddItineraryForSchoollList> createState() =>
      _StudentsAddItineraryForSchoollListState();
}

class _StudentsAddItineraryForSchoollListState
    extends State<StudentsAddItineraryForSchoollList> {
  // Lista de estudantes filtrados (mantida para referência, mas não mais para controle de seleção)
  List<Student> filteredStudents = [];

  // Mudança: Map para controlar a seleção de cada estudante
  Map<String, bool> selectedStudents = {};

  @override
  Widget build(BuildContext context) {
    final appUser = context.read<AppAuthProvider>().appUser;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Alunos da Escola ${widget.school.name}',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                height: MediaQuery.of(context).size.height * 0.9,
                child: FutureBuilder<List<Student>>(
                  initialData: const [],
                  future: appUser?.type == UserType.admin
                      ? context
                          .read<StudentProvider>()
                          .getStudentsBySchoolIsNotAuthorized(widget.school.id!)
                      : context
                          .read<StudentProvider>()
                          .getStudentsBySchoolIsWithoutInitinerary(
                              widget.school.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Erro: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Nenhum estudante para inserir.',
                              style: TextStyle(fontSize: 18)));
                    }

                    final students = snapshot.data!;

                    // Inicializa o estado de seleção para cada estudante se ainda não estiver definido
                    for (var student in students) {
                      selectedStudents.putIfAbsent(student.id!, () => false);
                    }

                    return ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return _studentCard(student, appUser!);
                      },
                    );
                  },
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppUiConfig.themeCustom.primaryColor,
        onPressed: appUser?.type == UserType.admin
            ? () {
                // Processa apenas os estudantes selecionados
                for (var student in filteredStudents) {
                  context
                      .read<ItineraryProvider>()
                      .addStudentToItineraryByAdmin(
                          itineraryId: widget.itinerary!.id!, student: student);
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            : () {
                // Processa apenas os estudantes selecionados
                for (var student in filteredStudents) {
                  context
                      .read<ItineraryProvider>()
                      .addStudentToItineraryBySchoolMember(
                          itineraryId: widget.itinerary!.id!,
                          studentId: student.id!);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }

  Card _studentCard(Student student, AppUser appUser) {
    if (student.imageUrl!.isEmpty) {
      return Card(
        color: getColorByAbsences(student.countAbsences()),
        child: ListTile(
          title: appUser.type == UserType.admin
              ? Column(
                  children: [
                    const Text(
                      'O termo já foi aprovado.',
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                )
              : Text(
                  student.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
          subtitle: Text(
            'CPF: ${student.cpf}\nFaltas: ${student.countAbsences()}',
            style: const TextStyle(fontSize: 16),
          ),
          trailing: Checkbox(
            value: selectedStudents[student.id],
            onChanged: (bool? value) {
              setState(() {
                selectedStudents[student.id!] = value!;
                // Atualiza a lista de estudantes filtrados com base na seleção
                if (value) {
                  filteredStudents.add(student);
                } else {
                  filteredStudents.removeWhere((s) => s.id == student.id);
                }
              });
            },
          ),
        ),
      );
    }
    return Card(
      color: getColorByAbsences(student.countAbsences()),
      child: ListTile(
        title: appUser.type == UserType.admin
            ? Column(
                children: [
                  if (!kIsWeb) // Se não for web, tenta carregar a imagem.
                    Image.network(
                      student.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return const Text(
                          'Erro ao carregar imagem',
                          style: TextStyle(color: Colors.red),
                        );
                      },
                    )
                  else // Se for web, mostra o link.
                    InkWell(
                      onTap: () => launchUrl(Uri.parse(student.imageUrl!)),
                      child: const Text(
                        'Clique aqui para ver a imagem',
                        style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              )
            : Text(
                student.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
        subtitle: Text(
          'CPF: ${student.cpf}\nFaltas: ${student.countAbsences()}',
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Checkbox(
          value: selectedStudents[student.id],
          onChanged: (bool? value) {
            setState(() {
              selectedStudents[student.id!] = value!;
              // Atualiza a lista de estudantes filtrados com base na seleção
              if (value) {
                filteredStudents.add(student);
              } else {
                filteredStudents.removeWhere((s) => s.id == student.id);
              }
            });
          },
        ),
      ),
    );
  }
}
