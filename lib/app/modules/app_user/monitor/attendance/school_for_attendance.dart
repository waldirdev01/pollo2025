// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../../../models/app_user.dart';
import '../../../../models/itinerary.dart';
import '../../../../models/school.dart';
import '../../../../models/student.dart';
import '../../../../providers/app_user_provider.dart';
import '../../../student/faltosos_report.dart';
import 'attendance_repport.dart';
import 'reposition_report.dart';

class SchoolsForAttendance extends StatefulWidget {
  const SchoolsForAttendance(
      {super.key,
      required this.schools,
      required this.itinerary,
      required this.month,
      required this.students});
  final List<School> schools;
  final Itinerary itinerary;
  final int month;
  final List<Student> students;

  @override
  State<SchoolsForAttendance> createState() => _SchoolsForAttendanceState();
}

class _SchoolsForAttendanceState extends State<SchoolsForAttendance> {
  bool isReposition =
      false; // Adiciona uma variável para armazenar a escolha do usuário
  bool isMonitor = true;
  DateTime now = DateTime.now();

  void _previewPdf(int month, List<Student> students, School school) async {
    AppUser? monitorUser;
    await Provider.of<AppUserProvider>(context, listen: false)
        .getMonitora(widget.itinerary.appUserId);
    monitorUser = Provider.of<AppUserProvider>(context, listen: false).typeUser;

    // Usa a escolha do usuário para determinar que tipo de relatório gerar
    Future<Uint8List> Function(PdfPageFormat) buildPdf;
    if (isReposition) {
      buildPdf = (format) async =>
          await RepositionReport.generateRepositionAttendanceReport(
            itinerary: widget.itinerary,
            students: students,
            school: school,
            month: widget.month,
            monitor: monitorUser,
          );
    } else {
      buildPdf =
          (format) async => await AttendanceReport.generateAttendanceReport(
                itinerary: widget.itinerary,
                students: students,
                school: school,
                month: widget.month,
                monitor: monitorUser,
              );
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text('Frequência gerada.')),
          body: PdfPreview(
            build: buildPdf,
          ),
        ),
      ),
    );
  }

  void _pdfFaltosos(int month, List<Student>? students, School school) async {
    AppUser? monitorUser;
    await Provider.of<AppUserProvider>(context, listen: false)
        .getMonitora(widget.itinerary.appUserId);
    monitorUser = Provider.of<AppUserProvider>(context, listen: false).typeUser;

    // Usa a escolha do usuário para determinar que tipo de relatório gerar
    Future<Uint8List> Function(PdfPageFormat) buildPdf;
    if (students != null) {
      buildPdf = (format) async => await FaltososReport.genetateListFaltosos(
            itinerary: widget.itinerary,
            students: students,
            school: school,
            month: widget.month,
            monitor: monitorUser,
          );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text('Lista gerada.')),
            body: PdfPreview(
              build: buildPdf,
            ),
          ),
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (context) => const Dialog(
                child: Text('Nao há alunos com 20 faltas ou mais'),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Imprimir frequência'),
        actions: <Widget>[
          Switch(
            activeColor: Colors.white,
            value: isReposition,
            onChanged: (value) {
              setState(() {
                isReposition = value;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: widget.schools.length,
            itemBuilder: (context, index) {
              List<Student> studentsBySchool = widget.students.where((element) {
                return element.schoolId == widget.schools[index].id;
              }).toList();
              List<Student>? studentsFaltosos = studentsBySchool.where(
                (element) {
                  return element.countAbsences() >= 20;
                },
              ).toList();
              return Card(
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.elliptical(10, 20))),
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        widget.schools[index].name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            _pdfFaltosos(widget.month, studentsFaltosos,
                                widget.schools[index]);
                          },
                          child: const Text(
                            'Infrequentes',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _previewPdf(widget.month, studentsBySchool,
                              widget.schools[index]);
                        },
                        icon: const Icon(
                          Icons.print,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
