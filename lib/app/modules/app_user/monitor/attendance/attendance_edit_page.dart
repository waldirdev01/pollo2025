// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/providers/app_auth_provider.dart';

import '../../../../models/app_user.dart';
import '../../../../models/attendance.dart';
import '../../../../models/itinerary.dart';
import '../../../../models/school.dart';
import '../../../../models/student.dart';
import '../../../../providers/school_provider.dart';
import '../../../../providers/student_provider.dart';

class AttendanceEditPage extends StatefulWidget {
  List<Student> students;
  final Itinerary itinerary;

  AttendanceEditPage(
      {super.key, required this.students, required this.itinerary});

  @override
  _AttendanceEditPageState createState() => _AttendanceEditPageState();
}

class _AttendanceEditPageState extends State<AttendanceEditPage> {
  bool isReposition = false;
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
        _loadAttendancesForSelectedDate();
      });
    }
  }

  List<Attendance> attendances = [];

  bool _isLoading = false;

  void _loadAttendancesForSelectedDate() {
    attendances = widget.students.map((student) {
      return student.attendance.firstWhere(
        (attendance) =>
            attendance.dateTime.year == _selectedDate.year &&
            attendance.dateTime.month == _selectedDate.month &&
            attendance.dateTime.day == _selectedDate.day,
        orElse: () => Attendance(
          going: false,
          returning: false,
          justifiedAbsence: false,
          dateTime: _selectedDate,
          makeUpDay: isReposition,
        ),
      );
    }).toList();
  }

  Future<void> _saveAttendance() async {
    setState(() {
      _isLoading = true;
    });

    List<Student> updatedStudents = [];

    for (int i = 0; i < widget.students.length; i++) {
      final student = widget.students[i].copyWith();
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

      updatedStudents.add(student);
    }

    setState(() {
      widget.students = updatedStudents;
      _isLoading = false;
    });

    Navigator.of(context).pop();
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
    _loadAttendancesForSelectedDate();
  }

  @override
  Widget build(BuildContext context) {
    List<School> matchingSchools = [];

    final schoolProvider = Provider.of<SchoolProvider>(context, listen: false);
    schoolProvider.getSchools();
    final List<Student> students = widget.students;
    final List<Student> studentsBySchool = [];
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
          Switch(
            activeColor: Colors.white,
            value: isReposition,
            onChanged: (value) {
              setState(() {
                isReposition = value;
              });
            },
          ),
          IconButton(
            onPressed: _isLoading ? null : _saveAttendance,
            icon: const Icon(Icons.save, color: Colors.white),
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
              ],
            ),
    );
  }
}
