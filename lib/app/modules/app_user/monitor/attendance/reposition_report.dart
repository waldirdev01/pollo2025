import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

import '../../../../models/app_user.dart';
import '../../../../models/attendance.dart';
import '../../../../models/itinerary.dart';
import '../../../../models/school.dart';
import '../../../../models/student.dart';

class RepositionReport {
  static Future<Uint8List> generateRepositionAttendanceReport(
      {required Itinerary itinerary,
      required int month,
      required School school,
      required List<Student> students,
      AppUser? monitor,
      int? numberStudentsOfSchool}) async {
    String? fullName = monitor?.name;
    if (monitor?.name == null) {
      fullName = 'MonitoraNãoCadastrada';
    }
    List<String>? nameParts = fullName?.split(' ');
    String? firstName = nameParts?.first.toUpperCase();
    final pdf = pw.Document();
    final fontBold =
        pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'));
    final fontRegular =
        pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'));

    final monthName = DateFormat.MMMM('pt_BR').format(DateTime(2023, month));
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
                  'REGISTRO DE FREQUÊNCIA MENSAL - TRANSPORTE ESCOLAR - - CONTRATO ${itinerary.contract}',
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
            4: const pw.FlexColumnWidth(4),
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
                    pw.Text('Dias letivos',
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

      int daysInMonth(int month) {
        DateTime firstDayThisMonth = DateTime(DateTime.now().year, month, 1);
        DateTime firstDayNextMonth =
            (DateTime(DateTime.now().year, month + 1, 1));
        return (firstDayNextMonth.difference(firstDayThisMonth).inDays);
      }

      final int days = daysInMonth(month);

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
            ...List<pw.Widget>.generate(days, (int index) {
              return pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                child: pw.Text((index + 1).toString().padLeft(2, '0'),
                    style: pw.TextStyle(font: fontRegular, fontSize: 6),
                    textAlign: pw.TextAlign.center),
              );
            }),
          ],
        ),
      );

      List<pw.Widget> buildEmptyCells(int lines) {
        return List<pw.Widget>.generate(lines, (index) {
          return pw.Container(
            alignment: pw.Alignment.center,
            width: 12,
            color: PdfColors.grey300,
          );
        });
      }

      // Data rows
      for (Student student in students) {
        int lines = (student.name.length / 35).ceil();
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
              ...List<pw.Widget>.generate(days, (int index) {
                Attendance attendance = student.attendance.firstWhere(
                  (a) =>
                      a.dateTime.month == month &&
                      a.dateTime.day == index + 1 &&
                      a.makeUpDay == true,
                  orElse: () => Attendance(
                      going: false,
                      returning: false,
                      justifiedAbsence: false,
                      dateTime: DateTime.utc(0),
                      makeUpDay: true),
                );

                String valueGoing = '';
                String valueReturning = '';
                String valueJustified = '';

                if (attendance.dateTime.month == month &&
                    attendance.dateTime.day == index + 1) {
                  valueGoing = attendance.going ? '*' : 'F';
                  valueReturning = attendance.returning ? '*' : 'F';
                  valueJustified = attendance.justifiedAbsence ? 'J' : '';

                  // Verifica a combinação de ausências justificadas e presenças para ida e volta
                  if (valueJustified.isNotEmpty) {
                    // Caso especial onde ambas ida e volta são ausentes e justificadas
                    if (valueGoing == 'F' && valueReturning == 'F') {
                      return pw.Container(
                        width: 6,
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            // Justificativa aparece duas vezes, uma para ida e outra para volta
                            pw.Text(valueJustified,
                                style:
                                    pw.TextStyle(font: fontBold, fontSize: 6),
                                textAlign: pw.TextAlign.center),
                            pw.Text(valueJustified,
                                style:
                                    pw.TextStyle(font: fontBold, fontSize: 6),
                                textAlign: pw.TextAlign.center),
                          ],
                        ),
                      );
                    } else {
                      // Ausência justificada para ida ou volta, mas não ambas
                      return pw.Container(
                        width: 6,
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                                valueGoing == 'F' ? valueJustified : valueGoing,
                                style:
                                    pw.TextStyle(font: fontBold, fontSize: 6),
                                textAlign: pw.TextAlign.center),
                            pw.Text(
                                valueReturning == 'F'
                                    ? valueJustified
                                    : valueReturning,
                                style:
                                    pw.TextStyle(font: fontBold, fontSize: 6),
                                textAlign: pw.TextAlign.center),
                          ],
                        ),
                      );
                    }
                  } else {
                    // Nenhuma ausência justificada, mostra ida e volta normalmente
                    return pw.Container(
                      width: 6,
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(valueGoing,
                              style: pw.TextStyle(font: fontBold, fontSize: 6),
                              textAlign: pw.TextAlign.center),
                          pw.Text(valueReturning,
                              style: pw.TextStyle(font: fontBold, fontSize: 6),
                              textAlign: pw.TextAlign.center),
                        ],
                      ),
                    );
                  }
                } else {
                  // Para dias sem registros de presença correspondentes, retorna células vazias
                  return pw.Column(
                    children: buildEmptyCells(lines),
                  );
                }
              }),
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

    pw.Widget contModEnsi() {
      Map<String, int> quantidades = {};
      for (Student student in students) {
        if (quantidades.containsKey(student.level)) {
          quantidades[student.level] = (quantidades[student.level] ?? 0) + 1;
        } else {
          quantidades[student.level] = 1;
        }
      }

      return pw.Table(
        border: pw.TableBorder.all(color: PdfColors.black, width: 1),
        columnWidths: {
          0: const pw.FlexColumnWidth(1.5),
          1: const pw.FlexColumnWidth(0.8),
          2: const pw.FlexColumnWidth(1),
          3: const pw.FlexColumnWidth(0.6),
          4: const pw.FlexColumnWidth(0.8),
          5: const pw.FlexColumnWidth(0.4),
          6: const pw.FlexColumnWidth(0.8),
          7: const pw.FlexColumnWidth(0.6),
          8: const pw.FlexColumnWidth(8),
        },
        children: [
          pw.TableRow(
            verticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: [
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 2),
                    child: pw.Text('TOTAl ALUNOS POR OFERTA DE ENSINO',
                        style: const pw.TextStyle(fontSize: 6),
                        textAlign: pw.TextAlign.center),
                  )
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text(
                    'INTEGRAL',
                    style: pw.TextStyle(
                        fontSize: 6, fontWeight: pw.FontWeight.bold),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text('${quantidades['INTEGRAL'] ?? 0}',
                      style: const pw.TextStyle(fontSize: 6),
                      textAlign: pw.TextAlign.center),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text('FUNDAMENTAL',
                      style: pw.TextStyle(fontSize: 6, font: fontBold),
                      textAlign: pw.TextAlign.center),
                  pw.Text('${quantidades['FUNDAMENTAL'] ?? 0}',
                      style: pw.TextStyle(fontSize: 6, font: fontBold),
                      textAlign: pw.TextAlign.center),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text('MÉDIO',
                      style: pw.TextStyle(fontSize: 6, font: fontBold),
                      textAlign: pw.TextAlign.center),
                  pw.Text('${quantidades['MÉDIO'] ?? 0}',
                      style: pw.TextStyle(fontSize: 6, font: fontBold),
                      textAlign: pw.TextAlign.center),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text('ESPECIAL',
                      style: pw.TextStyle(fontSize: 6, font: fontBold),
                      textAlign: pw.TextAlign.center),
                  pw.Text('${quantidades['ESPECIAL'] ?? 0}',
                      style: pw.TextStyle(fontSize: 6, font: fontBold),
                      textAlign: pw.TextAlign.center),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text('EJA',
                      style: pw.TextStyle(fontSize: 6, font: fontBold),
                      textAlign: pw.TextAlign.center),
                  pw.Text('${quantidades['EJA'] ?? 0}',
                      style: pw.TextStyle(fontSize: 6, font: fontBold),
                      textAlign: pw.TextAlign.center),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text('INFANTIL',
                      style: pw.TextStyle(fontSize: 6, font: fontBold),
                      textAlign: pw.TextAlign.center),
                  pw.Text('${quantidades['INFANTIL'] ?? 0}',
                      style: pw.TextStyle(fontSize: 6, font: fontBold),
                      textAlign: pw.TextAlign.center),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text('TOTAL',
                      style: pw.TextStyle(fontSize: 6, font: fontBold),
                      textAlign: pw.TextAlign.center),
                  pw.Text('${students.length}',
                      style: pw.TextStyle(fontSize: 6, font: fontBold),
                      textAlign: pw.TextAlign.center),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text('ANOTAÇÕES IMPORTANTES',
                      style: pw.TextStyle(fontSize: 6, font: fontBold),
                      textAlign: pw.TextAlign.center),
                  pw.Text('${itinerary.importantAnnotation}',
                      style: pw.TextStyle(fontSize: 6, font: fontBold),
                      textAlign: pw.TextAlign.center),
                  pw.Divider(borderStyle: pw.BorderStyle.none),
                ],
              ),
            ],
          ),
        ],
      );
    }

    pw.Widget atesto() {
      return pw.Column(children: [
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.black),
          children: [
            pw.TableRow(
              verticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 43),
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '1 - ESTA PLANILHA É DE PORTE OBRIGATÓRIO DURANTE O TRAJETO, SOB PENA  DE APLICAÇÃO DE PENALIDADE.',
                          style: const pw.TextStyle(
                              fontSize: 5, color: PdfColors.black),
                          textAlign: pw.TextAlign.justify,
                        ),
                        pw.Text(
                          '2- A FREQUÊNCIA DOS ALUNOS DEVE SER FEITA DIARIAMENTE NA IDA E NA VOLTA, MOTIVO PELO QUAL O CAMPO - DIA LETIVO - DIVIDE-SE EM DUAS PARTES.',
                          style: const pw.TextStyle(
                              fontSize: 5, color: PdfColors.black),
                          textAlign: pw.TextAlign.justify,
                        ),
                        pw.Text(
                          '3- O QUANTITATIVO DOS ALUNOS POR MODALIDADE DE ENSINO DEVE SER PREENCHIDA DE FORMA FIDEDIGNA, TENDO EM VISTA SER PARÂMENTRO PARA O PAGAMENTO.',
                          style: const pw.TextStyle(
                              fontSize: 5, color: PdfColors.black),
                          textAlign: pw.TextAlign.justify,
                        ),
                        pw.Text(
                          '4- SENHORES DIRETORES E SECRETÁRIOS, O ATESTO DEVERÁ ESTAR CONDIZENTE COM O DO DIÁRIO DE CLASSE.',
                          style: const pw.TextStyle(
                              fontSize: 5, color: PdfColors.black),
                          textAlign: pw.TextAlign.justify,
                        ),
                      ]),
                ),
                pw.Container(
                    alignment: pw.Alignment.bottomCenter,
                    child: pw.Text(
                      '                                  Assinatura da monitora                                     ',
                      style: const pw.TextStyle(
                          fontSize: 6, color: PdfColors.black),
                      textAlign: pw.TextAlign.center,
                    ))
              ],
            ),
          ],
        ),
        pw.Table(border: pw.TableBorder.all(color: PdfColors.black), children: [
          pw.TableRow(
            children: [
              pw.Container(height: 25),
            ],
          ),
          pw.TableRow(
            children: [
              pw.Container(
                  child: pw.Text(
                'Atesto que a frequência dos alunos está condizente com a do diário de classe.',
                style: const pw.TextStyle(fontSize: 6, color: PdfColors.red),
                textAlign: pw.TextAlign.center,
              )),
              pw.Container(
                  child: pw.Text(
                'Atesto que a frequência dos alunos está condizente com a do diário de classe.',
                style: const pw.TextStyle(fontSize: 6, color: PdfColors.red),
                textAlign: pw.TextAlign.center,
              )),
            ],
          ),
          pw.TableRow(
            children: [
              pw.Container(
                child: pw.Text(
                  'Diretor da escola',
                  style: const pw.TextStyle(fontSize: 6),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                  child: pw.Text(
                'Chefe de secretaria da escola',
                style: const pw.TextStyle(fontSize: 6),
                textAlign: pw.TextAlign.center,
              )),
              pw.Container(
                  child: pw.Text(
                '                         Representante da empresa                    ',
                style: const pw.TextStyle(fontSize: 6),
                textAlign: pw.TextAlign.center,
              ))
            ],
          ),
          pw.TableRow(
            children: [
              pw.Container(
                child: pw.Text(
                  'Matrícula: ',
                  style: const pw.TextStyle(fontSize: 6),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Container(
                  child: pw.Text(
                'Matrícula: ',
                style: const pw.TextStyle(fontSize: 6),
                textAlign: pw.TextAlign.center,
              ))
            ],
          ),
          pw.TableRow(
            children: [
              pw.Container(
                child: pw.Text(
                  'Escola: ${school.name}',
                  style: const pw.TextStyle(fontSize: 6),
                  textAlign: pw.TextAlign.left,
                ),
              ),
              pw.Container(
                  child: pw.Text(
                'Telefone:                                                   Código INEP:              ',
                style: const pw.TextStyle(fontSize: 6),
                textAlign: pw.TextAlign.left,
              )),
              pw.Container(
                  child: pw.Text(
                'TOTAL DE ALUNOS DA ESCOLA $numberStudentsOfSchool:                                                   Código INEP:              ',
                style: const pw.TextStyle(fontSize: 6),
                textAlign: pw.TextAlign.left,
              )),
            ],
          ),
        ]),
      ]);
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
            contModEnsi(),
            atesto(),
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
