// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/modules/app_user/monitor/attendance/attendance_edit_page.dart';
import 'package:pollo2025/app/modules/app_user/monitor/attendance/reposition_page.dart';
import 'package:pollo2025/app/modules/home_page.dart';
import 'package:pollo2025/app/providers/app_auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../../models/app_user.dart';
import '../../../../models/attendance.dart';
import '../../../../models/itinerary.dart';
import '../../../../models/school.dart';
import '../../../../models/student.dart';
import '../../../../providers/school_provider.dart';
import '../../../../providers/student_provider.dart';
import 'school_for_attendance.dart';

class AttendancePage extends StatefulWidget {
  List<Student> students;
  final Itinerary itinerary;

  AttendancePage({super.key, required this.students, required this.itinerary});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  DateTime _selectedDate = DateTime.now();
  AppUser? _appUser;
  late School matchingSchool;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2023),
        lastDate: DateTime(2028));

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        attendances = List.generate(
          widget.students.length,
          (index) => Attendance(
              going: true,
              returning: true,
              justifiedAbsence: false,
              dateTime: _selectedDate,
              makeUpDay: false),
        );
      });
    }
  }

  List<Attendance> attendances = [];

  bool _isLoading = false;

  navigatorRepositionScreen(Itinerary itinerary, List<Student> students) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              RepositionPage(itinerary: itinerary, students: students)),
    );
  }

  navigatorEditScreen(Itinerary itinerary, List<Student> students) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              AttendanceEditPage(itinerary: itinerary, students: students)),
    );
  }

  Future<void> _navigateAfterAttendanceAction() async {
    if (_appUser?.type == UserType.monitor) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Constants.kUSERMONITORHOMEPAGEROUTE, (route) => false,
          arguments: _appUser);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    }
  }

  Future<void> _saveAttendance() async {
    // Marque o estado como carregando antes de iniciar a operação
    setState(() {
      _isLoading = true;
    });

    List<Student> updatedStudents =
        []; // Lista temporária para armazenar estudantes atualizados

    for (int i = 0; i < widget.students.length; i++) {
      final student = widget.students[i]
          .copyWith(); // Método de cópia para evitar mutação direta
      final attendance = attendances[i];

      final existingAttendanceIndex = student.attendance.indexWhere(
        (a) =>
            a.dateTime.year == _selectedDate.year &&
            a.dateTime.month == _selectedDate.month &&
            a.dateTime.day == _selectedDate.day,
      );

      if (existingAttendanceIndex != -1) {
        student.attendance[existingAttendanceIndex] = attendance;
      } else {
        student.attendance.add(attendance);
      }

      await context
          .read<StudentProvider>()
          .updateAttendance(student.id!, student.attendance);

      updatedStudents
          .add(student); // Adicione o estudante atualizado à lista temporária
    }

    // Agora atualize o estado uma única vez fora do loop
    setState(() {
      widget.students = updatedStudents;
      _isLoading = false;
    });

    _navigateAfterAttendanceAction(); // Função de navegação após a ação (como mencionado em sugestões anteriores)
  }

  Future<void> _deleteAttendance() async {
    setState(() {
      _isLoading = true;
    });

    List<Student> updatedStudents = [];

    for (Student student in widget.students) {
      final copiedStudent =
          student.copyWith(); // Criando uma cópia do estudante

      try {
        // Encontre a data do registro de chamada que você deseja deletar.
        Attendance attendanceToDelete = copiedStudent.attendance.firstWhere(
          (a) =>
              a.dateTime.year == _selectedDate.year &&
              a.dateTime.month == _selectedDate.month &&
              a.dateTime.day == _selectedDate.day,
        );

        // Se encontrarmos uma correspondência, vamos deletá-la.
        copiedStudent.attendance.remove(attendanceToDelete);
        await context
            .read<StudentProvider>()
            .deleteAttendance(copiedStudent.id!, attendanceToDelete.dateTime);
      } on StateError {
        // Não encontramos nenhum Attendance correspondente à data selecionada.
        // Não fazemos nada e continuamos para o próximo estudante.
      }

      updatedStudents.add(copiedStudent);
    }

    // Atualizando a lista de estudantes
    setState(() {
      widget.students = updatedStudents;
      _isLoading = false;
    });

    _navigateAfterAttendanceAction();
  }

  Future<void> _initAppUser() async {
    final userProvider = Provider.of<AppAuthProvider>(context, listen: false);

    _appUser = userProvider.appUser;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initAppUser();
    attendances = List.generate(
      widget.students.length,
      (index) => Attendance(
        going: true,
        returning: true,
        justifiedAbsence: false,
        dateTime: _selectedDate,
        makeUpDay: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<School> matchingSchools = [];

    final schoolProvider = Provider.of<SchoolProvider>(context, listen: false);
    schoolProvider.getSchools();
    final List<Student> students = widget.students;
    final List<Student> studentsBySchool = [];
    print(students);
    for (final student in students) {
      final schoolId = student.schoolId;
      final School defaultSchool = School(
        id: "",
        type: '',
        name: "",
        phone: "",
        inep: "",
        principalName: "",
        principalRegister: "",
        secretaryName: "",
        secretaryRegister: "",
        studentsId: [],
      );

      matchingSchool = schoolProvider.schools.firstWhere(
        (school) => school.id == schoolId,
        orElse: () => defaultSchool,
      );

      if (matchingSchool != defaultSchool &&
          !matchingSchools.contains(matchingSchool)) {
        matchingSchools.add(matchingSchool);
      }
      if (student.schoolId == matchingSchool.id) {
        studentsBySchool.add(student);
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            TextButton.icon(
              onPressed: () => _selectDate(context),
              icon: const Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              label: Text(DateFormat('dd/MM/yyyy').format(_selectedDate),
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _isLoading
                ? null
                : _appUser?.type == UserType.monitor
                    ? _saveAttendance
                    : null,
            icon: Icon(Icons.save,
                color: _appUser?.type == UserType.monitor
                    ? Colors.white
                    : Colors.grey),
          ),
          IconButton(
            onPressed: _isLoading
                ? null
                : () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SchoolsForAttendance(
                          schools: matchingSchools,
                          itinerary: widget.itinerary,
                          month: _selectedDate.month,
                          students: studentsBySchool,
                        ))),
            icon:
                const Icon(Icons.arrow_circle_right_sharp, color: Colors.white),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.students.length,
                    itemBuilder: (context, index) {
                      final student = widget.students[index];
                      final attendance = attendances[index];
                      final canEdit = _appUser?.type == UserType.monitor;
                      return Card(
                        child: ExpansionTile(
                          title: Text(student.name),
                          subtitle: Text(matchingSchool.name),
                          children: [
                            CheckboxListTile(
                              title: const Text('Ida'),
                              value: attendance.going,
                              onChanged: canEdit
                                  ? (value) {
                                      setState(() {
                                        attendance.going = value ?? false;
                                      });
                                    }
                                  : null,
                            ),
                            CheckboxListTile(
                              title: const Text('Volta'),
                              value: attendance.returning,
                              onChanged: canEdit
                                  ? (value) {
                                      setState(() {
                                        attendance.returning = value ?? false;
                                      });
                                    }
                                  : null,
                            ),
                            CheckboxListTile(
                              title: const Text('Falta justificada'),
                              value: attendance.justifiedAbsence,
                              onChanged: canEdit
                                  ? (value) {
                                      setState(() {
                                        attendance.justifiedAbsence =
                                            value ?? false;
                                        attendance.returning = false;
                                        attendance.going = false;
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    _appUser?.type != UserType.monitor
                        ? const SizedBox.shrink()
                        : ElevatedButton(
                            style: AppUiConfig.elevatedButtonThemeCustom,
                            onPressed: _deleteAttendance,
                            child: const Text('Excluir um dia da chamada',
                                style: TextStyle(color: Colors.white)),
                          ),
                    const Divider(),
                    _appUser?.type != UserType.monitor
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              ElevatedButton(
                                style: AppUiConfig.elevatedButtonThemeCustom,
                                onPressed: () => navigatorRepositionScreen(
                                    widget.itinerary, widget.students),
                                child: const Text('Ir para reposição',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              ElevatedButton(
                                style: AppUiConfig.elevatedButtonThemeCustom,
                                onPressed: () => navigatorEditScreen(
                                    widget.itinerary, widget.students),
                                child: const Text('Editar chamada',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          )
                  ],
                )
              ],
            ),
    );
  }
}
