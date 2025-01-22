import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pollo2025/app/models/extracurricular_activity.dart';
import "package:universal_html/html.dart" as html;

class ECGenerateMemo {
  static Future<Uint8List> generateMemo(
      ExtracurricularActivity extracurricularActivity,
      String schoolName) async {
    double totalKm = extracurricularActivity.kilometerOfBus *
        extracurricularActivity.quantityOfBus;
    final pdf = pw.Document();
    final monthName = DateFormat.MMMM('pt_BR')
        .format(DateTime(2024, extracurricularActivity.dateOfEvent.month));

    final imageGDF = pw.MemoryImage(
        (await rootBundle.load('assets/images/logo_df.png'))
            .buffer
            .asUint8List());

    pw.Widget buildHeader(pw.Context context) {
      return pw.Header(
          child:
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
        pw.Container(
            child: pw.Image(
          imageGDF,
          width: 50,
          height: 50,
        )),
        pw.SizedBox(width: 150),
        pw.Column(children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Governo do Distrito Federal',
                  textAlign: pw.TextAlign.justify,
                  style: const pw.TextStyle(fontSize: 8)),
              pw.Text('Secretaria de Estado de Educação do Distrito Federal,',
                  style: const pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.justify),
              pw.Text('Coordenação Regional de Ensino do Paranoá',
                  style: const pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.justify),
              pw.Text(schoolName,
                  style: const pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.justify),
              pw.SizedBox(height: 8),
            ],
          ),
        ])
      ]));
    }

    pw.Widget cabecalho(String monthName) {
      return pw.Column(children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                      'Memorando Nº ${extracurricularActivity.memo}-SEE/CREPAR/$schoolName',
                      style: const pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.left),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(right: 20),
                    child: pw.Text(
                        DateFormat(" d 'de' MMMM 'de' y.", 'pt_BR')
                            .format(DateTime.now()),
                        style: const pw.TextStyle(fontSize: 8),
                        textAlign: pw.TextAlign.center),
                  ),
                ]),
            pw.Text('À UNIAE,',
                style: const pw.TextStyle(fontSize: 8),
                textAlign: pw.TextAlign.justify),
            pw.SizedBox(height: 8),
            pw.Text(
                'Solicitamos a autorização para a realização da atividade extracurricular ${extracurricularActivity.title}, no dia ${DateFormat('dd/MM/yyyy').format(extracurricularActivity.dateOfEvent)}.',
                style: const pw.TextStyle(fontSize: 8),
                textAlign: pw.TextAlign.justify),
            pw.SizedBox(height: 8),
          ],
        ),
      ]);
    }

    pw.Widget infPedagogicas() {
      List<pw.TableRow> rows = [];
      rows.add(pw.TableRow(children: [
        pw.Text('INFORMAÇÕES PEDAGÓGICAS',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
      ]));

      rows.add(pw.TableRow(children: [
        pw.Text('Temática: ${extracurricularActivity.title}',
            style: const pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.justify),
      ]));

      rows.add(pw.TableRow(children: [
        pw.Text(
            'Disciplinas envolvidas: ${extracurricularActivity.subject.name}',
            style: const pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.justify),
      ]));

      rows.add(pw.TableRow(children: [
        pw.Text(
            'Contúdos e habilidades do currículo: ${extracurricularActivity.setOfThemes}',
            style: const pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.justify),
      ]));

      rows.add(pw.TableRow(children: [
        pw.Text(
            'Possíveis habilidades desenvolvidas após a atividade: ${extracurricularActivity.skillsToDevelop}',
            style: const pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.justify),
      ]));

      return pw.Table(
        border: pw.TableBorder.all(color: PdfColors.black, width: 1),
        children: rows,
      );
    }

    pw.Widget infoScholDate() {
      List<pw.TableRow> rows = [];
      rows.add(pw.TableRow(children: [
        pw.Text('UNIDADE ESCOLAR: $schoolName',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
      ]));

      rows.add(pw.TableRow(children: [
        pw.Text(
            'DATA DO EVENTO: ${DateFormat('dd/MM/yyyy').format(extracurricularActivity.dateOfEvent)}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
      ]));

      rows.add(pw.TableRow(children: [
        pw.Text('LOCAL DO EVENTO: ${extracurricularActivity.local}',
            style: const pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.justify),
      ]));

      return pw.Table(
          border: pw.TableBorder.all(color: PdfColors.black, width: 1),
          children: rows);
    }

    pw.Widget infTransp() {
      List<pw.TableRow> rows = [];
      rows.add(pw.TableRow(children: [
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text('TURNO',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text('EMBARQUE (IDA/VOLTA)',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text('Nº DE ALUNOS',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text('Nº DE ÔNIBUS',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text('KM POR ÔNIBUS',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text('KM TOTAL',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
        ),
      ]));
      rows.add(pw.TableRow(children: [
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text('MATUTINO',
              textAlign: pw.TextAlign.left,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveMorning.isEmpty ? "" : extracurricularActivity.leaveMorning} / ${extracurricularActivity.returnMorning.isEmpty ? "" : extracurricularActivity.returnMorning}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveMorning.isEmpty ? 0 : extracurricularActivity.students.length}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveMorning.isEmpty ? 0 : extracurricularActivity.quantityOfBus}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveMorning.isEmpty ? 0 : extracurricularActivity.kilometerOfBus}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveMorning.isEmpty ? 0 : totalKm.toStringAsFixed(1)}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
      ]));
      rows.add(pw.TableRow(children: [
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text('VESPERTINO',
              textAlign: pw.TextAlign.left,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveAfternoon.isEmpty ? "" : extracurricularActivity.leaveAfternoon} / ${extracurricularActivity.returnAfternoon.isEmpty ? "" : extracurricularActivity.returnAfternoon}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveAfternoon.isEmpty ? 0 : extracurricularActivity.students.length}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveAfternoon.isEmpty ? 0 : extracurricularActivity.quantityOfBus}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveAfternoon.isEmpty ? 0 : extracurricularActivity.kilometerOfBus}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveAfternoon.isEmpty ? 0 : totalKm.toStringAsFixed(1)}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
      ]));
      rows.add(pw.TableRow(children: [
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text('NOTURNO',
              textAlign: pw.TextAlign.left,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveNight.isEmpty ? "" : extracurricularActivity.leaveNight} / ${extracurricularActivity.returnNight.isEmpty ? "" : extracurricularActivity.returnNight}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveNight.isEmpty ? 0 : extracurricularActivity.students.length}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveNight.isEmpty ? 0 : extracurricularActivity.quantityOfBus}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveNight.isEmpty ? 0 : extracurricularActivity.kilometerOfBus}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1)),
          child: pw.Text(
              '${extracurricularActivity.leaveNight.isEmpty ? 0 : totalKm.toStringAsFixed(1)}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.center),
        ),
      ]));

      return pw.Table(
        columnWidths: {
          0: const pw.FlexColumnWidth(1),
          1: const pw.FlexColumnWidth(1),
          2: const pw.FlexColumnWidth(1),
          3: const pw.FlexColumnWidth(1),
          4: const pw.FlexColumnWidth(1),
        },
        border: pw.TableBorder.all(color: PdfColors.black, width: 1),
        children: rows,
      );
    }

    pw.Widget students() {
      List<pw.TableRow> rows = [];

      rows.add(pw.TableRow(children: [
        pw.Text('ESTUDANTES',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
      ]));

      for (var student in extracurricularActivity.students) {
        rows.add(pw.TableRow(children: [
          pw.Text(student.name,
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.justify),
        ]));
      }

      return pw.Table(
        border: pw.TableBorder.all(color: PdfColors.black, width: 1),
        children: rows,
      );
    }

    pdf.addPage(
      pw.MultiPage(
        header: (pw.Context context) => buildHeader(context),
        margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        orientation: pw.PageOrientation.portrait,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            cabecalho(monthName),
            pw.SizedBox(height: 8),
            infPedagogicas(),
            pw.SizedBox(height: 8),
            infoScholDate(),
            pw.SizedBox(height: 8),
            pw.Text(
                'INFORMAÇÕES DE TRANSPORTE (estimativa de distância do percurso por meio do Google Maps)',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
            infTransp(),
            infoScholDate(),
            pw.SizedBox(height: 8),
            pw.Paragraph(
                text: 'Professores: ${extracurricularActivity.teachers}',
                style: const pw.TextStyle(fontSize: 8)),
            pw.SizedBox(height: 8),
            students(),
            pw.SizedBox(height: 8),
            pw.Text('Atenciosamente,',
                style: const pw.TextStyle(fontSize: 8),
                textAlign: pw.TextAlign.justify),
          ];
        },
      ),
    );
    final Uint8List pdfBytes = await pdf.save();

    if (kIsWeb) {
      // Código para web usando universal_html
      final blob = html.Blob([pdfBytes], 'memorando/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // ignore: unused_local_variable
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'memorando.pdf')
        ..click();

      html.Url.revokeObjectUrl(url);
    } else {
      // Código para outras plataformas (Android, iOS, etc.)
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/memorando.pdf');
      await file.writeAsBytes(pdfBytes);

      // Você pode agora abrir o arquivo para impressão ou compartilhamento, etc.
    }
    return pdf.save();
  }
}
