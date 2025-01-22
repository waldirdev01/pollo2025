// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/providers/app_auth_provider.dart';

import '../../../../models/app_user.dart';
import '../../../../models/attendance.dart';
import '../../../../models/itinerary.dart';
import '../../../../models/school.dart';
import '../../../../models/student.dart';
import '../../../../providers/app_user_provider.dart';
import '../../../../providers/school_provider.dart';
import '../../../../providers/student_provider.dart';
import 'school_for_attendance.dart';

class RepositionPage extends StatefulWidget {
  final List<Student> students;
  final Itinerary itinerary;

  const RepositionPage(
      {super.key, required this.students, required this.itinerary});

  @override
  _RepositionPageState createState() => _RepositionPageState();
}

class _RepositionPageState extends State<RepositionPage> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2028),
    );

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
              makeUpDay: true),
        );
      });
    }
  }

  List<Attendance> attendances = [];

  bool _isLoading = false;

  Future<void> _navigateToNextScreen() async {
    final appUser =
        Provider.of<AppUserProvider>(context, listen: false).typeUser;
    String newRouteName = Constants.kHOMEROUTE;

    if (appUser?.type == UserType.monitor) {
      newRouteName = Constants.kUSERMONITORHOMEPAGEROUTE;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
        newRouteName, (route) => false,
        arguments: appUser);
  }

  Future<void> _saveRepositionAttendance() async {
    try {
      setState(() {
        _isLoading = true;
      });
      for (int i = 0; i < widget.students.length; i++) {
        final student = widget.students[i];
        final attendance = Attendance(
          going: attendances[i].going,
          returning: attendances[i].returning,
          justifiedAbsence: attendances[i].justifiedAbsence,
          dateTime: attendances[i].dateTime,
          makeUpDay: true, // Mark this attendance as a makeup day
        );
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
      }
      _navigateToNextScreen(); // Move this outside of the loop
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _initMonitor() async {
    final userProvider = Provider.of<AppUserProvider>(context, listen: false);
    await userProvider.getMonitora(widget.itinerary.appUserId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initMonitor();
    attendances = List.generate(
      widget.students.length,
      (index) => Attendance(
        going: true,
        returning: true,
        justifiedAbsence: false,
        dateTime: _selectedDate,
        makeUpDay: true,
      ),
    );
  }

  School? matchingSchool;
  @override
  Widget build(BuildContext context) {
    return Consumer<AppAuthProvider>(
      builder: (context, appUserProvider, child) {
        final appUser = appUserProvider.appUser;
        final canEdit = appUser?.type == UserType.monitor;
        final schoolProvider =
            Provider.of<SchoolProvider>(context, listen: false);
        List<School> matchingSchools = [];
        final List<Student> students = widget.students;
        List<Student> studentsBySchool = [];

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
            matchingSchools.add(matchingSchool!);
          }
          if (student.schoolId == matchingSchool?.name) {
            studentsBySchool.add(student);
          }
        }

        return Scaffold(
          appBar: AppBar(
            iconTheme: AppUiConfig.iconThemeCustom(),
            title: Row(
              children: [
                TextButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    label: Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDate),
                      style: const TextStyle(color: Colors.white),
                    )),
              ],
            ),
            actions: [
              IconButton(
                onPressed: _isLoading
                    ? null
                    : canEdit
                        ? _saveRepositionAttendance
                        : null,
                icon: Icon(
                  Icons.save,
                  color: canEdit ? Colors.white : Colors.grey,
                ),
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
                icon: const Icon(
                  Icons.arrow_circle_right_sharp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.students.length,
                        itemBuilder: (context, index) {
                          final student = widget.students[index];
                          final attendance = attendances[index];
                          return Card(
                            child: ExpansionTile(
                              title: Text(student.name),
                              subtitle: Text(matchingSchool!.name.isEmpty
                                  ? 'Escola não encontrada'
                                  : matchingSchool!.name),
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
                                            attendance.returning =
                                                value ?? false;
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
      },
    );
  }
}
