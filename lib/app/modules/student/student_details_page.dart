import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/app_user.dart';
import 'package:pollo2025/app/providers/app_auth_provider.dart';
import 'package:pollo2025/app/providers/student_provider.dart';

import '../../models/incident.dart';
import '../../models/itinerary.dart';
import '../../models/pne.dart';
import '../../models/school.dart';
import '../../models/student.dart';
import '../../providers/itinerary_provider.dart';
import '../../providers/school_provider.dart';
import '../incidents/incident_create_form.dart';

class StudentDetailsPage extends StatefulWidget {
  final Student student;

  const StudentDetailsPage({super.key, required this.student});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  Itinerary? itineraryLoaded;
  List<Incident> incidents = [];
  Future<List<Incident>>? loadedIncidents;
  School? school;
  Future<void> loadIncidents() async {
    incidents = await context
        .read<StudentProvider>()
        .getIncidentsByStudent(widget.student.id!);
  }

  Future<Itinerary> getItinerary(String id) async {
    return await context.read<ItineraryProvider>().getItinerary(id);
  }

  @override
  void initState() {
    super.initState();
    loadIncidents();
    getItinerary(widget.student.itineraryId)
        .then((value) => itineraryLoaded = value);
  }

  @override
  Widget build(BuildContext context) {
    final schoolProvider = Provider.of<SchoolProvider>(context);
    schoolProvider.getSchool(widget.student.schoolId);
    school = schoolProvider.school;
    final appUser = context.read<AppAuthProvider>().appUser;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Detalhes do estudante',
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppUiConfig.themeCustom.primaryColor,
              ),
              child: const Center(
                child: Icon(Icons.menu, size: 100, color: Colors.white),
              ),
            ),
            Card(
              color: AppUiConfig.themeCustom.primaryColor,
              child: ListTile(
                title:
                    const Text('Voltar', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                trailing: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            Card(
              color: AppUiConfig.themeCustom.primaryColor,
              child: ListTile(
                title: const Text('Editar estudante',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pushNamed(Constants.kSTUDENTEDITROUTE,
                      arguments: widget.student);
                },
                trailing: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
            Card(
              color: AppUiConfig.themeCustom.primaryColor,
              child: ListTile(
                title: const Text('Registrar incidente',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          IncidentCreateForm(student: widget.student)));
                },
                trailing: const Icon(
                  Icons.report_problem,
                  color: Colors.yellow,
                ),
              ),
            ),
            Card(
              color: appUser?.type != UserType.admin
                  ? Colors.grey
                  : AppUiConfig.themeCustom.primaryColor,
              child: ListTile(
                title: const Text('Excluir estudante',
                    style: TextStyle(color: Colors.white)),
                onTap: appUser?.type != UserType.admin
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Excluir estudante'),
                              content: const Text(
                                  'Tem certeza que deseja excluir este estudante?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Excluir'),
                                  onPressed: () {
                                    context
                                        .read<StudentProvider>()
                                        .deleteStudent(widget.student.id!,
                                            school!.id!, itineraryLoaded!.id!);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                trailing: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
              ),
            ),
            Card(
              color: AppUiConfig.themeCustom.primaryColor,
              child: ListTile(
                title: const Text('Sair do aplicativo',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  context.read<AppAuthProvider>().logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      Constants.kUSERLOGINROUTE, (route) => false);
                },
                trailing: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: itineraryLoaded != null
          ? SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                    color: getColorByAbsences(widget.student.countAbsences()),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppUiConfig.themeCustom.primaryColor, width: 2)),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nome: ${widget.student.name}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text('I-Educar: ${widget.student.ieducar}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('Turma: ${widget.student.classroomGrade}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('Escola: ${school?.name}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    appUser?.type == UserType.monitor
                        ? const SizedBox()
                        : Text('CPF: ${widget.student.cpf}',
                            style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('Itinerário: ${itineraryLoaded?.code}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    const SizedBox(height: 4),
                    Text('Modalidade: ${widget.student.level}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('Residencia: ${widget.student.residenceType}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('PNE: ${describePne(widget.student.pne.type)}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                        widget.student.requiresGuardian
                            ? 'Acompanhante: Sim'
                            : 'Acompanhante: Não',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Text(
                        widget.student.differentiated != ''
                            ? 'Diferenciado: ${widget.student.differentiated}'
                            : 'Diferenciado: Não',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Text('Faltas: ${widget.student.countAbsences()}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Text(
                        'Data de cadastro: ${DateFormat('dd/MM/yyyy, HH:mm').format(widget.student.createdAt)}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: incidents.length,
                        itemBuilder: (BuildContext context, int index) {
                          final incident = incidents[index];
                          return InkWell(
                            onTap: incident.cient == true
                                ? null
                                : () => showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Dar ciência no incidente'),
                                        content: const Text(
                                            'Confirme que tomou ciência do fato'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                incident.appUserName =
                                                    appUser!.name;
                                                incident.dateCient =
                                                    DateTime.now();
                                                incident.cient = true;
                                                context
                                                    .read<StudentProvider>()
                                                    .updateStudentIncident(
                                                        widget.student.id!,
                                                        incident);
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: const Text('Ciente'),
                                          ),
                                        ],
                                      );
                                    }),
                            child: Card(
                              child: ListTile(
                                title: Text(incident.description),
                                subtitle: Column(
                                  children: [
                                    Text(incident.appUserName),
                                    Text(DateFormat('dd/MM/yyyy')
                                        .format(incident.dateCreate)),
                                  ],
                                ),
                                leading: Icon(
                                  Icons.report_problem,
                                  color: incident.cient == true
                                      ? AppUiConfig.themeCustom.primaryColor
                                      : Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text('O estudante não está em nenhum itinerário!')),
    );
  }
}
