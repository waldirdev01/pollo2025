import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/providers/student_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/custom_home_card.dart';
import '../../models/school.dart';

class SchoolData extends StatefulWidget {
  const SchoolData({super.key, required this.school});
  final School school;

  @override
  State<SchoolData> createState() => _SchoolDataState();
}

class _SchoolDataState extends State<SchoolData> {
  int? totalStudents;
  int? studentPNE;
  int? studentRural;
  int? studentsUrban;
  int? studentsvisualImpairment;
  int? studentsWheelchairUser;
  int? studentsAutistic;
  int? studentsGuardian;

  @override
  void initState() {
    super.initState();

    // Aqui você pode chamar as funções para obter os dados
    context.read<StudentProvider>().getStudentsBySchool(widget.school.id!);

    context
        .read<StudentProvider>()
        .getNumberTotalStudentBySchool(widget.school.id!)
        .then((value) => setState(() => totalStudents = value));

    context
        .read<StudentProvider>()
        .getNumberStudentPNEBySchool(widget.school.id!)
        .then((value) => setState(() => studentPNE = value));

    context
        .read<StudentProvider>()
        .getNumberStudentRuralResidenceBySchool(widget.school.id!)
        .then((value) => setState(() => studentRural = value));

    context
        .read<StudentProvider>()
        .getNumberStudentPNEvisualImpairmentBySchool(widget.school.id!)
        .then((value) => setState(() => studentsvisualImpairment = value));

    context
        .read<StudentProvider>()
        .getAutisticBySchool(widget.school.id!)
        .then((value) => setState(() => studentsAutistic = value));

    context
        .read<StudentProvider>()
        .getwheelchairUserBySchool(widget.school.id!)
        .then((value) => setState(() => studentsWheelchairUser = value));

    context
        .read<StudentProvider>()
        .getStudentsRequeriesGuardianBySchool(widget.school.id!)
        .then((value) => setState(() => studentsGuardian = value));

    context
        .read<StudentProvider>()
        .getNumberStudentUrbanResidenceBySchool(widget.school.id!)
        .then((value) => setState(() => studentsUrban = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Quantidades de estudantes',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            CustomHomeCard(
              icon: Icons.groups,
              text: 'Total de alunos\n ${totalStudents ?? 0}',
              onTap: () {},
            ),
            CustomHomeCard(
              icon: Icons.accessibility,
              text: studentPNE == null
                  ? 'Alunos PNE'
                  : 'Alunos PNE\n $studentPNE',
              onTap: () {},
            ),
            CustomHomeCard(
              icon: Icons.blind,
              text: studentsvisualImpairment == null
                  ? 'PNE DV'
                  : 'PNE DV\n $studentsvisualImpairment',
              onTap: () {},
            ),
            CustomHomeCard(
              icon: Icons.settings_accessibility,
              text: studentsvisualImpairment == null
                  ? 'Autistas'
                  : 'Autistas\n $studentsAutistic',
              onTap: () {},
            ),
            CustomHomeCard(
              icon: Icons.accessible_forward,
              text: studentsWheelchairUser == null
                  ? 'Cadeirante'
                  : 'Cadeirante\n $studentsWheelchairUser',
              onTap: () {},
            ),
            CustomHomeCard(
              icon: Icons.people,
              text: studentsGuardian == null
                  ? 'Com acompanhante'
                  : 'Com acompanhante\n $studentsGuardian',
              onTap: () {},
            ),
            CustomHomeCard(
              icon: Icons.agriculture,
              text: studentRural == null
                  ? 'Zona rural'
                  : 'Zona rural\n $studentRural',
              onTap: () {},
            ),
            CustomHomeCard(
              icon: Icons.location_city,
              text: studentsUrban == null
                  ? 'Zona urbana'
                  : 'Urbana\n ${studentsUrban ?? 0}',
              onTap: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Usa a escolha do usuário para determinar que tipo de relatório gerar
          Future<Uint8List> Function(PdfPageFormat) buildPdf;
          buildPdf = (format) async => await PDFGenerator.generatePDF(
                school: widget.school,
                totalStudents: widget.school.studentsId!.length,
                studentPNE: studentPNE,
                studentRural: studentRural,
                studentsUrban: studentsUrban,
                studentsvisualImpairment: studentsvisualImpairment,
                studentsWheelchairUser: studentsWheelchairUser,
                studentsAutistic: studentsAutistic,
                studentsGuardian: studentsGuardian,
              );

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                    iconTheme: const IconThemeData(color: Colors.white),
                    title: const Text('Frequência de gerada.')),
                body: PdfPreview(
                  build: buildPdf,
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.print),
      ),
    );
  }
}

class PDFGenerator {
  static Future<Uint8List> generatePDF({
    required School school,
    required int totalStudents,
    int? studentPNE,
    int? studentRural,
    int? studentsUrban,
    int? studentsvisualImpairment,
    int? studentsWheelchairUser,
    int? studentsAutistic,
    int? studentsGuardian,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                // Título
                pw.Text(
                  'Relatório da Escola ${school.name}',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blueGrey800,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Divider(
                  color: PdfColors.blue,
                  thickness: 2,
                ),
                // Corpo do relatório
                _buildSection('Total de Alunos:', totalStudents.toString()),
                _buildSection(
                  'Alunos PNE:',
                  studentPNE?.toString() ?? 'Não disponível',
                ),
                _buildSection('Alunos da Zona Rural:',
                    studentRural?.toString() ?? 'Não disponível'),
                _buildSection('Alunos da Zona Urbana:',
                    studentsUrban?.toString() ?? 'Não disponível'),
                _buildSection('Alunos com Deficiência Visual:',
                    studentsvisualImpairment?.toString() ?? 'Não disponível'),
                _buildSection('Alunos Autistas:',
                    studentsAutistic?.toString() ?? 'Não disponível'),
                _buildSection('Alunos Usuários de Cadeira de Rodas:',
                    studentsWheelchairUser?.toString() ?? 'Não disponível'),
                _buildSection('Alunos com Acompanhante:',
                    studentsGuardian?.toString() ?? 'Não disponível'),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildSection(String label, String value,
      {PdfColor? color}) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Text(label,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: color ?? PdfColors.blueGrey800,
                )),
          ),
          pw.Text(value,
              style: pw.TextStyle(
                fontSize: 18,
                color: color ?? PdfColors.black,
              )),
        ],
      ),
    );
  }
}
