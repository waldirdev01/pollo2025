import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/providers/itinerary_provider.dart';
import 'package:pollo2025/app/providers/school_provider.dart';
import 'package:pollo2025/app/providers/student_provider.dart';

import '../../../../core/widgets/custom_home_card.dart';

class DataCompany extends StatefulWidget {
  const DataCompany({super.key});

  @override
  State<DataCompany> createState() => _DataCompanyState();
}

class _DataCompanyState extends State<DataCompany> {
  int? totalStudents;
  int? studentPNE;
  int? studentRural;
  int? studentsUrban;
  int? studentsvisualImpairment;
  int? studentsWheelchairUser;
  int? studentsAutistic;
  int? studentsGuardian;
  int? schoolUrban;
  int? schoolRural;
  int? totalSchools;
  int? totalItineraries;
  int? itinerariesUrban;
  int? itinerariesRural;
  int? itinerariesMix;
  int? itinerariesIntegral;
  int? itinerariesRegular;

  @override
  void initState() {
    super.initState();
    // Aqui você pode chamar as funções para obter os dados

    context
        .read<StudentProvider>()
        .getNumberTotalStudents()
        .then((value) => setState(() => totalStudents = value));
    context
        .read<StudentProvider>()
        .getNumberStudentPNE()
        .then((value) => setState(() => studentPNE = value));

    context
        .read<StudentProvider>()
        .getNumberStudentRuralResidence()
        .then((value) => setState(() => studentRural = value));

    context
        .read<StudentProvider>()
        .getNumberStudentPNEvisualImpairment()
        .then((value) => setState(() => studentsvisualImpairment = value));

    context
        .read<StudentProvider>()
        .getAutistic()
        .then((value) => setState(() => studentsAutistic = value));

    context
        .read<StudentProvider>()
        .getwheelchairUser()
        .then((value) => setState(() => studentsWheelchairUser = value));

    context
        .read<StudentProvider>()
        .getStudentsRequeriesGuardian()
        .then((value) => setState(() => studentsGuardian = value));

    context
        .read<StudentProvider>()
        .getNumberStudentUrbanResidence()
        .then((value) => setState(() => studentsUrban = value));
    context
        .read<SchoolProvider>()
        .getNumberSchoolUrbanLocation()
        .then((value) => setState(() => schoolUrban = value));
    context
        .read<SchoolProvider>()
        .getNumberSchoolRuralLocation()
        .then((value) => setState(() => schoolRural = value));

    context
        .read<SchoolProvider>()
        .getNumberTotalSchools()
        .then((value) => setState(() => totalSchools = value));

    context.read<ItineraryProvider>().getNumberTotalItineraries().then((value) {
      setState(() {
        totalItineraries = value;
      });
    });

    context
        .read<ItineraryProvider>()
        .getNumberItineraryUrbanLocation()
        .then((value) => setState(() => itinerariesUrban = value));

    context
        .read<ItineraryProvider>()
        .getNumberItineraryRuralLocation()
        .then((value) => setState(() => itinerariesRural = value));

    context
        .read<ItineraryProvider>()
        .getNumberItineraryMixLocation()
        .then((value) => setState(() => itinerariesMix = value));

    context
        .read<ItineraryProvider>()
        .getNumberItineraryIntegral()
        .then((value) {
      setState(() {
        itinerariesIntegral = value;
      });
    });

    context.read<ItineraryProvider>().getNumberItineraryRegular().then((value) {
      setState(() {
        itinerariesRegular = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Dados da ${Constants.kCOMPANYNAME}',
      ),
      body: totalStudents != null && totalStudents! > 0
          ? Padding(
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
                  CustomHomeCard(
                    icon: Icons.school,
                    text: totalSchools == null
                        ? 'Total de escolas'
                        : 'Total de escolas\n ${totalSchools ?? 0}',
                    onTap: () {},
                  ),
                  CustomHomeCard(
                    icon: Icons.location_city,
                    text: schoolUrban == null
                        ? 'Escolas urbanas'
                        : 'Escolas urbanas\n ${schoolUrban ?? 0}',
                    onTap: () {},
                  ),
                  CustomHomeCard(
                    icon: Icons.agriculture,
                    text: schoolRural == null
                        ? 'Escolas rurais'
                        : 'Escolas rurais\n ${schoolRural ?? 0}',
                    onTap: () {},
                  ),
                  CustomHomeCard(
                    icon: Icons.route,
                    text: totalItineraries == null
                        ? 'Total de itinerários'
                        : 'Total de itinerários\n ${totalItineraries ?? 0}',
                    onTap: () {},
                  ),
                  CustomHomeCard(
                    icon: Icons.location_city,
                    text: itinerariesUrban == null
                        ? 'Itinerários urbanos'
                        : 'Itinerários urbanos\n ${itinerariesUrban ?? 0}',
                    onTap: () {},
                  ),
                  CustomHomeCard(
                    icon: Icons.agriculture,
                    text: itinerariesRural == null
                        ? 'Itinerários rurais'
                        : 'Itinerários rurais\n ${itinerariesRural ?? 0}',
                    onTap: () {},
                  ),
                  CustomHomeCard(
                    icon: Icons.route,
                    text: itinerariesMix == null
                        ? 'Itinerários mistos'
                        : 'Itinerários mistos\n ${itinerariesMix ?? 0}',
                    onTap: () {},
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(
                        color: Colors.deepPurple,
                        width: 1.0,
                      ),
                    ),
                    elevation: 8,
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.all_inclusive,
                            size: 48,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            itinerariesIntegral == null
                                ? 'Itinerários integrais'
                                : 'Itinerários integrais\n ${itinerariesIntegral ?? 0}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            itinerariesRegular == null
                                ? 'Itinerários regulares'
                                : 'Itinerários regulares\n ${itinerariesRegular ?? 0}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () async {
          // Usa a escolha do usuário para determinar que tipo de relatório gerar
          Future<Uint8List> Function(PdfPageFormat) buildPdf;
          buildPdf = (format) async => await PDFGenerator.generatePDF(
                totalStudents: totalStudents ?? 0,
                studentPNE: studentPNE,
                studentRural: studentRural,
                studentsUrban: studentsUrban,
                studentsvisualImpairment: studentsvisualImpairment,
                studentsWheelchairUser: studentsWheelchairUser,
                studentsAutistic: studentsAutistic,
                studentsGuardian: studentsGuardian,
                schoolUrban: schoolUrban,
                schoolRural: schoolRural,
                totalSchools: totalSchools,
                totalItineraries: totalItineraries,
                itinerariesUrban: itinerariesUrban,
                itinerariesRural: itinerariesRural,
                itinerariesMix: itinerariesMix,
                itinerariesIntegral: itinerariesIntegral,
                itinerariesRegular: itinerariesRegular,
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
    required int totalStudents,
    int? studentPNE,
    int? studentRural,
    int? studentsUrban,
    int? studentsvisualImpairment,
    int? studentsWheelchairUser,
    int? studentsAutistic,
    int? studentsGuardian,
    int? schoolUrban,
    int? schoolRural,
    int? totalSchools,
    int? totalItineraries,
    int? itinerariesUrban,
    int? itinerariesRural,
    int? itinerariesMix,
    int? itinerariesIntegral,
    int? itinerariesRegular,
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
                  'Relatório da ${Constants.kCOMPANYNAME}',
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
                pw.Divider(
                  color: PdfColors.blue,
                  thickness: 2,
                ),
                _buildSection('Total de Escolas:', totalSchools.toString()),
                _buildSection('Escolas Urbanas:', schoolUrban.toString()),
                _buildSection('Escolas Rurais:', schoolRural.toString()),
                pw.Divider(
                  color: PdfColors.blue,
                  thickness: 2,
                ),
                _buildSection(
                    'Total de Itinerários:', totalItineraries.toString()),
                _buildSection(
                    'Itinerários Urbanos:', itinerariesUrban.toString()),
                _buildSection(
                    'Itinerários Rurais:', itinerariesRural.toString()),
                _buildSection('Itinerários mistos', itinerariesMix.toString()),
                _buildSection(
                    'Itinerários Integrais:', itinerariesIntegral.toString()),
                _buildSection(
                    'Itinerários Regulares:', itinerariesRegular.toString()),
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
