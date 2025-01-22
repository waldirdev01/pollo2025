import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pollo2025/app/models/itinerary.dart';
import "package:universal_html/html.dart" as html;

import '../../../../models/app_user.dart';
import '../../../../models/school.dart';
import '../../../../models/student.dart';

class FaltososReport {
  static Future<Uint8List> genetateListFaltosos({
    required Itinerary itinerary,
    required int month,
    required School school,
    required List<Student> students,
    AppUser? monitor,
  }) async {
    String? fullName = monitor?.name;
    if (monitor?.name == null) {
      fullName = 'MonitoraNãoCadastrada';
    }
    List<String>? nameParts = fullName?.split(' ');
    String? firstName = nameParts?.first.toUpperCase();
    final monthName = DateFormat.MMMM('pt_BR').format(DateTime(2024, month));
    final pdf = pw.Document();
    final fontBold =
        pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'));
    final fontRegular =
        pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'));
    pw.Widget buildHeader(
        pw.Context context, pw.Font fontBold, String monthName) {
      return pw.Column(children: [
        pw.Container(
            decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: 1)),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'LISTA DE ALUNOS COM MAIS DE 20 FALTAS - TRANSPORTE ESCOLAR - - CONTRATO ${itinerary.contract}',
                  style: pw.TextStyle(fontSize: 10, font: fontBold),
                ),
                pw.SizedBox(width: 100),
                pw.Text(
                  monthName,
                  style: pw.TextStyle(fontSize: 12, font: fontBold),
                ),
              ],
            )),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.black, width: 1),
          columnWidths: {
            0: const pw.FlexColumnWidth(0.8),
            1: const pw.FlexColumnWidth(0.6),
            2: const pw.FlexColumnWidth(0.8),
            3: const pw.FlexColumnWidth(0.6),
            4: const pw.FlexColumnWidth(0.8),
          },
          children: [
            pw.TableRow(
              children: [
                pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        pw.Text(itinerary.code,
                            style: pw.TextStyle(
                                fontSize: 8, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center),
                        pw.Text('Motorista: ${itinerary.driverName}',
                            style: const pw.TextStyle(fontSize: 6),
                            textAlign: pw.TextAlign.center),
                        pw.Text('Telefone: ${itinerary.driverPhone}',
                            style: const pw.TextStyle(fontSize: 6),
                            textAlign: pw.TextAlign.center),
                        pw.Text('CNH: ${itinerary.driverLicence}',
                            style: const pw.TextStyle(fontSize: 6),
                            textAlign: pw.TextAlign.center),
                      ],
                    )),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Text('ESCOLA',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                    pw.Text(school.name,
                        style: const pw.TextStyle(fontSize: 8),
                        textAlign: pw.TextAlign.center),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 2),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Text(
                        itinerary.shift,
                        style: pw.TextStyle(
                            fontSize: 8, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text('MONITORA: $firstName',
                          style: const pw.TextStyle(fontSize: 6),
                          textAlign: pw.TextAlign.center),
                      pw.Text('TELEFONE: ${monitor?.phone}',
                          style: const pw.TextStyle(fontSize: 6),
                          textAlign: pw.TextAlign.center),
                      pw.Text(
                          'CPF: ${monitor?.cpf.substring(0, 3)}.${monitor?.cpf.substring(3, 6)}.${monitor?.cpf.substring(6, 9)}-${monitor?.cpf.substring(9)}',
                          style: const pw.TextStyle(fontSize: 6),
                          textAlign: pw.TextAlign.center),
                    ],
                  ),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'KM TOTAL',
                      style: pw.TextStyle(
                          fontSize: 6, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(itinerary.kilometer.toString(),
                        style: const pw.TextStyle(fontSize: 6),
                        textAlign: pw.TextAlign.left),
                    pw.Text('PLACA',
                        style: const pw.TextStyle(
                          fontSize: 6,
                        )),
                    pw.Text(itinerary.vehiclePlate,
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('ITINERÁRIO',
                        style: pw.TextStyle(fontSize: 6, font: fontBold),
                        textAlign: pw.TextAlign.center),
                    pw.Text(itinerary.trajectory,
                        style: pw.TextStyle(fontSize: 6, font: fontBold),
                        textAlign: pw.TextAlign.center),
                    pw.Text('Faltas',
                        style: pw.TextStyle(fontSize: 6, font: fontBold),
                        textAlign: pw.TextAlign.center),
                  ],
                ),
              ],
            ),
          ],
        ),
      ]);
    }

    pw.Widget buildAttendanceTable(pw.Context context, pw.Font fontRegular,
        List<Student> students, int month) {
      final List<pw.TableRow> rows = [];

      // Header row
      rows.add(
        pw.TableRow(
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 1),
              child: pw.Text('Nome',
                  style: pw.TextStyle(font: fontRegular, fontSize: 8)),
            ),
            pw.Container(
              width: 40,
              child: pw.Text('i-Educar',
                  style: pw.TextStyle(font: fontRegular, fontSize: 8),
                  textAlign: pw.TextAlign.center),
            ),
            pw.Container(
              child: pw.Text('CPF',
                  style: pw.TextStyle(font: fontRegular, fontSize: 8),
                  textAlign: pw.TextAlign.center),
            ),
            pw.Container(
              child: pw.Text('Mod. Ens',
                  style: pw.TextStyle(font: fontRegular, fontSize: 6),
                  textAlign: pw.TextAlign.center),
            ),
            pw.Container(
              child: pw.Text('Série/Turma',
                  style: pw.TextStyle(font: fontRegular, fontSize: 6),
                  textAlign: pw.TextAlign.center),
            ),
            pw.Container(
              child: pw.Text('Faltas',
                  style: pw.TextStyle(font: fontRegular, fontSize: 6),
                  textAlign: pw.TextAlign.center),
            ),
          ],
        ),
      );

      // Data rows
      for (Student student in students) {
        rows.add(
          pw.TableRow(
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 2),
                width: 140,
                child: pw.Text(student.name,
                    style: pw.TextStyle(font: fontRegular, fontSize: 6),
                    textAlign: pw.TextAlign.left),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                child: pw.Text(student.ieducar.toString(),
                    style: pw.TextStyle(
                      font: fontRegular,
                      fontSize: 6,
                    ),
                    textAlign: pw.TextAlign.center),
              ),
              pw.Container(
                width: 50,
                padding: const pw.EdgeInsets.all(1),
                child: pw.Text(
                    "${student.cpf.substring(0, 3)}.***.***-${student.cpf.substring(9)}",
                    style: pw.TextStyle(font: fontRegular, fontSize: 6),
                    textAlign: pw.TextAlign.center),
              ),
              pw.Container(
                width: 50,
                padding: const pw.EdgeInsets.symmetric(horizontal: 2),
                child: pw.Text(student.level,
                    style: pw.TextStyle(font: fontRegular, fontSize: 6),
                    textAlign: pw.TextAlign.center),
              ),
              pw.Container(
                width: 40,
                padding: const pw.EdgeInsets.symmetric(horizontal: 2),
                child: pw.Text(student.classroomGrade,
                    style: pw.TextStyle(font: fontRegular, fontSize: 6),
                    textAlign: pw.TextAlign.center),
              ),
              pw.Container(
                width: 40,
                padding: const pw.EdgeInsets.symmetric(horizontal: 2),
                child: pw.Text(student.countAbsences().toString(),
                    style: pw.TextStyle(font: fontRegular, fontSize: 6),
                    textAlign: pw.TextAlign.center),
              ),
            ],
          ),
        );
      }

      return pw.Table(
        border: const pw.TableBorder(
          bottom: pw.BorderSide(width: 1),
          horizontalInside: pw.BorderSide(width: 1),
          left: pw.BorderSide(width: 1),
          right: pw.BorderSide(width: 1),
          top: pw.BorderSide(width: 1),
          verticalInside: pw.BorderSide(width: 1),
        ),
        children: rows,
      );
    }

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(10),
        orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            buildHeader(context, fontBold, monthName),
            buildAttendanceTable(context, fontRegular, students, month),
          ];
        },
      ),
    );
    final Uint8List pdfBytes = await pdf.save();

    if (kIsWeb) {
      // Código para web usando universal_html
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // ignore: unused_local_variable
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'attendance_report.pdf')
        ..click();

      html.Url.revokeObjectUrl(url);
    } else {
      // Código para outras plataformas (Android, iOS, etc.)
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/attendance_report.pdf');
      await file.writeAsBytes(pdfBytes);

      // Você pode agora abrir o arquivo para impressão ou compartilhamento, etc.
    }
    return await pdf.save();
  }
}
