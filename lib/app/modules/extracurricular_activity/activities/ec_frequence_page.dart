import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/app_user.dart';
import 'package:pollo2025/app/models/extracurricular_activity.dart';
import 'package:pollo2025/app/modules/extracurricular_activity/activities/ec_report.dart';

class ECFrequencePage extends StatefulWidget {
  const ECFrequencePage(
      {super.key,
      required this.extracurricularActivity,
      required this.schoolNane,
      required this.monitora});
  final ExtracurricularActivity extracurricularActivity;
  final String schoolNane;
  final AppUser monitora;
  @override
  State<ECFrequencePage> createState() => _ECFrequencePageState();
}

class _ECFrequencePageState extends State<ECFrequencePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Frequência',
      ),
      body: ListView.builder(
        itemCount: widget.extracurricularActivity.students.length,
        itemBuilder: (context, index) {
          final student = widget.extracurricularActivity.students[index];
          return Card(
            color: AppUiConfig.themeCustom.primaryColor,
            child: ListTile(
              title: Text(student.name,
                  style: const TextStyle(color: Colors.white)),
              trailing: Checkbox(
                value: student.present,
                onChanged: (value) {
                  setState(() {
                    student.present = value!;
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppUiConfig.themeCustom.primaryColor,
        onPressed: () {
          _previewPdf(
              extracurricularActivity: widget.extracurricularActivity,
              nameSchool: widget.schoolNane,
              monitora: widget.monitora);
        },
        child: const Icon(Icons.print, color: Colors.white),
      ),
    );
  }

  Future<void> _previewPdf(
      {required ExtracurricularActivity extracurricularActivity,
      required String nameSchool,
      required AppUser monitora}) async {
    Future<Uint8List> Function(PdfPageFormat) buildPdf;

    buildPdf = (format) async => await ECReport.generateECAReport(
        extracurricularActivity: extracurricularActivity,
        nameSchool: nameSchool,
        monitora: monitora);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text('Relatório de Frequência'),
          ),
          body: PdfPreview(
            build: buildPdf,
          ),
        ),
      ),
    );
  }
}
