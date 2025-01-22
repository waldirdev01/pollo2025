import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/app_user.dart';
import 'package:pollo2025/app/models/extracurricular_activity.dart';
import 'package:pollo2025/app/modules/extracurricular_activity/activities/e_c_generate_memo.dart';
import 'package:pollo2025/app/modules/extracurricular_activity/activities/ec_frequence_page.dart';
import 'package:pollo2025/app/modules/extracurricular_activity/students_ec/e_c_students_list_by_school.dart';
import 'package:pollo2025/app/providers/app_auth_provider.dart';
import 'package:pollo2025/app/providers/e_c_activity_provider.dart';
import 'package:pollo2025/app/providers/school_provider.dart';

import '../../../providers/app_user_provider.dart';

class ECDetailsPage extends StatefulWidget {
  const ECDetailsPage({super.key, required this.ecActivity});
  final ExtracurricularActivity ecActivity;

  @override
  State<ECDetailsPage> createState() => _ECDetailsPageState();
}

class _ECDetailsPageState extends State<ECDetailsPage> {
  String nameSchool = '';
  Future<String> _getNameSchool(String schoolId) async {
    final school = await context.read<SchoolProvider>().getSchool(schoolId);
    return school.name;
  }

  AppUser? monitora;

  List<AppUser> monitorList = [];

  Future<void> _getMonitor(List<String> monitorsId) async {
    List<AppUser> tempMonitorList = [];
    if (widget.ecActivity.monitorsId.isNotEmpty) {
      for (var monitorId in widget.ecActivity.monitorsId) {
        await context.read<AppUserProvider>().getMonitora(monitorId);
        // ignore: use_build_context_synchronously
        monitora = context.read<AppUserProvider>().typeUser;
        if (monitora != null) {
          tempMonitorList.add(monitora!);
        }
      }
    }

    // Verifique se o widget ainda está montado antes de chamar setState
    if (mounted) {
      setState(() {
        monitorList = tempMonitorList;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getMonitor(widget.ecActivity.monitorsId);
  }

  @override
  Widget build(BuildContext context) {
    final appUser = context.read<AppAuthProvider>().appUser;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detalhes da Atividade',
        actions: appUser?.type != UserType.schoolMember
            ? null
            : [
                IconButton(
                    onPressed: () => _previewPdf(
                        extracurricularActivity: widget.ecActivity,
                        nameSchool: nameSchool),
                    icon: const Icon(Icons.picture_as_pdf)),
              ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<ExtracurricularActivity>(
            future: context
                .read<ECActivityProvider>()
                .getECActivity(widget.ecActivity.id!),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('Nenhum estado de conexão.');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('Nenhum dado disponível.');
                  } else {
                    final ecActivity = snapshot.data;
                    _getNameSchool(ecActivity!.schoolId);
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppUiConfig.themeCustom.primaryColor,
                              width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(04),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ecActivity.isDone
                                ? const Text('Atividade realizada',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green))
                                : const Text('Atividade não realizada',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
                            const SizedBox(height: 4),
                            FutureBuilder<String>(
                              future: _getNameSchool(ecActivity.schoolId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Erro: ${snapshot.error}');
                                }

                                nameSchool = snapshot.data ??
                                    'Nome da escola não disponível';
                                return Text('Escola: $nameSchool',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold));
                              },
                            ),
                            const SizedBox(height: 4),
                            Text('Código TCB: ${ecActivity.tcbCode}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Contrato: ${ecActivity.contract}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Temática: ${ecActivity.title}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Local do evento: ${ecActivity.local}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Disciplinas: ${ecActivity.subject.name}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                'Habilidades do currículo:  ${ecActivity.setOfThemes.isEmpty ? 'Não informado' : ecActivity.setOfThemes}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                'Desdobramentos pedagógicos:  ${ecActivity.skillsToDevelop.isEmpty ? 'Não informado' : ecActivity.skillsToDevelop}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              'Data da solicitação: ${DateFormat('dd/MM/yyyy').format(ecActivity.dateOfCreate)}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                                'Data do evento: ${DateFormat('dd/MM/yyyy').format(ecActivity.dateOfEvent)}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            ecActivity.leaveMorning.isEmpty
                                ? const SizedBox.shrink()
                                : Text(
                                    'Saída manhã: ${ecActivity.leaveMorning}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            ecActivity.returnMorning.isEmpty
                                ? const SizedBox.shrink()
                                : Text(
                                    'Retorno manhã: ${ecActivity.returnMorning}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            ecActivity.leaveAfternoon.isEmpty
                                ? const SizedBox.shrink()
                                : Text(
                                    'Saída tarde: ${ecActivity.leaveAfternoon}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            ecActivity.returnAfternoon.isEmpty
                                ? const SizedBox.shrink()
                                : Text(
                                    'Retorno tarde: ${ecActivity.returnAfternoon}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            ecActivity.leaveNight.isEmpty
                                ? const SizedBox.shrink()
                                : Text('Saída noite: ${ecActivity.leaveNight}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            ecActivity.returnNight.isEmpty
                                ? const SizedBox.shrink()
                                : Text(
                                    'Retorno noite: ${ecActivity.returnNight}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                'Placa do ônibus:  ${ecActivity.busPlate.isEmpty ? 'Não informado' : ecActivity.busPlate}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                'Motorista:  ${ecActivity.busDriver.isEmpty ? 'Não informado' : ecActivity.busDriver}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                'Telefone do motorista:  ${ecActivity.driverPhone.isEmpty ? 'Não informado' : ecActivity.driverPhone}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                'Monitoras:\n${monitorList.isEmpty ? 'Não informado' : monitorList.map((e) => e.name).join('\n')}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                'Professores:\n ${ecActivity.teachers.isEmpty ? 'Não informado' : ecActivity.teachers.split(',').join('\n')}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                'Quantidade de ônibus:  ${ecActivity.quantityOfBus}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                'Quilometragem por ônibus:  ${ecActivity.kilometerOfBus}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                'Quilometragem total:  ${ecActivity.kilometerOfBus * ecActivity.quantityOfBus}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                'Alunos:\n${ecActivity.students.isEmpty ? 'Nenhum aluno selecionado' : ecActivity.students.map((e) => e.name).join('\n')}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            ecActivity.students.isEmpty
                                ? const SizedBox.shrink()
                                : ElevatedButton(
                                    style:
                                        AppUiConfig.elevatedButtonThemeCustom,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ECFrequencePage(
                                                    extracurricularActivity:
                                                        ecActivity,
                                                    schoolNane: nameSchool,
                                                    monitora: monitorList.first,
                                                  )));
                                    },
                                    child: const Text('Ir para frequência',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                          ]),
                    );
                  }
              }
            }),
      ),
      floatingActionButton: appUser?.type == UserType.monitor ||
              appUser?.type == UserType.coordinator
          ? null
          : FloatingActionButton.extended(
              backgroundColor: AppUiConfig.themeCustom.primaryColor,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ECStudentsListBySchool(ecActivity: widget.ecActivity)));
              },
              label: const Text(
                'Adiconar Alunos',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
              ),
            ),
    );
  }

  Future<void> _previewPdf({
    required ExtracurricularActivity extracurricularActivity,
    required String nameSchool,
  }) async {
    Future<Uint8List> Function(PdfPageFormat) buildPdf;

    buildPdf = (format) async =>
        await ECGenerateMemo.generateMemo(extracurricularActivity, nameSchool);

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
