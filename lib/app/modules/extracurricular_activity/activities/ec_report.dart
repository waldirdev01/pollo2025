import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pollo2025/app/models/app_user.dart';
import 'package:pollo2025/app/models/extracurricular_activity.dart';
import "package:universal_html/html.dart" as html;

import '../../../models/e_c_student.dart';

class ECReport {
  static Future<Uint8List> generateECAReport(
      {required ExtracurricularActivity extracurricularActivity,
      required String nameSchool,
      required AppUser monitora}) async {
    final pdf = pw.Document();
    final monthName = DateFormat.MMMM('pt_BR')
        .format(DateTime(2024, extracurricularActivity.dateOfEvent.month));
    pw.Widget buildHeader(pw.Context context, String monthName) {
      return pw.Column(children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
                'ATIVIDADE EXTRACURRICULAR - ${extracurricularActivity.title} - Autorização ${extracurricularActivity.tcbCode}',
                textScaleFactor: 1.2,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center),
          ],
        ),
      ]);
    }

    pw.Widget buildHeaderFrequence(pw.Context context, String monthName) {
      return pw.Column(children: [
        pw.Container(
            decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: 1)),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'REGISTRO DE FREQUÊNCIA ATIVIDADE EXTRACURRICULAR - - CONTRATO ${extracurricularActivity.contract}',
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(width: 100),
                pw.Text(
                  monthName,
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ],
            )),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.black, width: 1),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1),
            3: const pw.FlexColumnWidth(1),
            4: const pw.FlexColumnWidth(1),
          },
          children: [
            pw.TableRow(
              children: [
                pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        pw.Text('MOTORISTA',
                            style: pw.TextStyle(
                                fontSize: 8, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center),
                        pw.Text(
                            'Motorista: ${extracurricularActivity.busDriver}',
                            style: const pw.TextStyle(fontSize: 6),
                            textAlign: pw.TextAlign.center),
                        pw.Text(
                            'Telefone: ${extracurricularActivity.driverPhone}',
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
                    pw.Text(nameSchool,
                        style: const pw.TextStyle(fontSize: 8),
                        textAlign: pw.TextAlign.center),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 2),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Text('MONITORA: ${monitora.name}',
                          style: const pw.TextStyle(fontSize: 6),
                          textAlign: pw.TextAlign.center),
                      pw.Text('TELEFONE: ${monitora.phone}',
                          style: const pw.TextStyle(fontSize: 6),
                          textAlign: pw.TextAlign.center),
                      pw.Text(
                          'CPF: ${monitora.cpf.substring(0, 3)}.${monitora.cpf.substring(3, 6)}.${monitora.cpf.substring(6, 9)}-${monitora.cpf.substring(9)}',
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
                    pw.Text(extracurricularActivity.kilometerOfBus.toString(),
                        style: const pw.TextStyle(fontSize: 6),
                        textAlign: pw.TextAlign.left),
                    pw.Text('PLACA',
                        style: const pw.TextStyle(
                          fontSize: 6,
                        )),
                    pw.Text(extracurricularActivity.busPlate,
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'LOCAL',
                      style: pw.TextStyle(
                          fontSize: 6, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      extracurricularActivity.local,
                      style: pw.TextStyle(
                          fontSize: 6, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ]);
    }

    pw.Widget frequencyTable(pw.Context context, List<ECStudent> students) {
      List<pw.TableRow> rows = [];
      for (var student in students) {
        rows.add(pw.TableRow(
            verticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 1)),
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(student.name,
                    style: const pw.TextStyle(fontSize: 8)),
              ),
              pw.Container(
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 1)),
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(student.present ? 'PRESENTE' : 'FALTOU',
                    style: const pw.TextStyle(fontSize: 8)),
              ),
            ]));
      }
      return pw.Table(children: rows);
    }

    pw.Widget contModEnsi() {
      Map<String, int> quantidades = {};
      for (ECStudent student in extracurricularActivity.students) {
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
                      style: const pw.TextStyle(
                        fontSize: 6,
                      ),
                      textAlign: pw.TextAlign.center),
                  pw.Text('${quantidades['FUNDAMENTAL'] ?? 0}',
                      style: const pw.TextStyle(
                        fontSize: 6,
                      ),
                      textAlign: pw.TextAlign.center),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text('MÉDIO',
                      style: const pw.TextStyle(
                        fontSize: 6,
                      ),
                      textAlign: pw.TextAlign.center),
                  pw.Text('${quantidades['MÉDIO'] ?? 0}',
                      style: const pw.TextStyle(
                        fontSize: 6,
                      ),
                      textAlign: pw.TextAlign.center),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text('ESPECIAL',
                      style: const pw.TextStyle(
                        fontSize: 6,
                      ),
                      textAlign: pw.TextAlign.center),
                  pw.Text('${quantidades['ESPECIAL'] ?? 0}',
                      style: const pw.TextStyle(
                        fontSize: 6,
                      ),
                      textAlign: pw.TextAlign.center),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text('EJA',
                      style: const pw.TextStyle(
                        fontSize: 6,
                      ),
                      textAlign: pw.TextAlign.center),
                  pw.Text('${quantidades['EJA'] ?? 0}',
                      style: const pw.TextStyle(
                        fontSize: 6,
                      ),
                      textAlign: pw.TextAlign.center),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text('INFANTIL',
                      style: const pw.TextStyle(
                        fontSize: 6,
                      ),
                      textAlign: pw.TextAlign.center),
                  pw.Text('${quantidades['INFANTIL'] ?? 0}',
                      style: const pw.TextStyle(
                        fontSize: 6,
                      ),
                      textAlign: pw.TextAlign.center),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text('TOTAL',
                      style: const pw.TextStyle(
                        fontSize: 6,
                      ),
                      textAlign: pw.TextAlign.center),
                  pw.Text('${extracurricularActivity.students.length}',
                      style: const pw.TextStyle(
                        fontSize: 6,
                      ),
                      textAlign: pw.TextAlign.center),
                ],
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text('ANOTAÇÕES IMPORTANTES',
                      style: const pw.TextStyle(
                        fontSize: 6,
                      ),
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
                  'Escola: $nameSchool',
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
                'TOTAL DE ALUNOS DA ESCOLA ${extracurricularActivity.students.length}:                                                   Código INEP:              ',
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
        margin: const pw.EdgeInsets.all(8),
        orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            buildHeader(context, DateFormat('MMMM').format(DateTime.now())),
            pw.SizedBox(height: 20),
            buildHeaderFrequence(context, monthName),
            frequencyTable(context, extracurricularActivity.students),
            contModEnsi(),
            atesto(),
          ];
        },
      ),
    );
    final Uint8List pdfBytes = await pdf.save();

    if (kIsWeb) {
      // Código para web usando universal_html
      final blob = html.Blob([pdfBytes], 'frequencia/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // ignore: unused_local_variable
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'frequencia.pdf')
        ..click();

      html.Url.revokeObjectUrl(url);
    } else {
      // Código para outras plataformas (Android, iOS, etc.)
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/frequencia.pdf');
      await file.writeAsBytes(pdfBytes);

      // Você pode agora abrir o arquivo para impressão ou compartilhamento, etc.
    }
    return await pdf.save();
  }
}
