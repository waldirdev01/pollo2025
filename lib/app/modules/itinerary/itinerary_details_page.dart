import 'package:flutter/material.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/modules/itinerary/widgets/monitoring_buttons.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/custom_app_bar.dart';
import '../../models/app_user.dart';
import '../../models/itinerary.dart';
import '../../models/school.dart';
import '../../models/student.dart';
import '../../providers/app_auth_provider.dart';
import '../../providers/app_user_provider.dart';
import '../../providers/itinerary_provider.dart';
import '../../providers/student_provider.dart';
import '../app_user/monitor/attendance/attendance.dart';
import '../student/student_details_page.dart';
import '../student/students_add_itineray_for_school_list.dart';
import '../student/widgets/student_card.dart';

class ItineraryDetailslPage extends StatelessWidget {
  ItineraryDetailslPage({super.key, required this.itinerary, this.school});
  Itinerary itinerary;
  final School? school;

  @override
  Widget build(BuildContext context) {
    final studentProvider = context.read<StudentProvider>();

    int vacances = 0;
    List<Student> studentsSelecteds = [];
    final userType = context.read<AppAuthProvider>().appUser!.type;

    return Scaffold(
        appBar: CustomAppBar(
            title: 'Detalhes do itinerário',
            actions: userType == UserType.admin && school != null
                ? [
                    PopupMenuButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      itemBuilder: ((context) => [
                            const PopupMenuItem(
                                value: 'add_studente',
                                child: Text('Adicionar estudante')),
                            const PopupMenuItem(
                                value: 'manager_monitor',
                                child: Text('Gerenciar monitora')),
                            const PopupMenuItem(
                                value: 'imprimir_frequencia',
                                child: Text('Ir para lista de frequência')),
                          ]),
                      onSelected: (value) {
                        switch (value) {
                          case 'add_studente':
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    StudentsAddItineraryForSchoollList(
                                      school: school!,
                                      itinerary: itinerary,
                                    )));
                            break;
                          case 'manager_monitor':
                            Navigator.of(context).pushNamed(
                                Constants.kUSERMONITORASFORITINERARYLISTROUTE,
                                arguments: itinerary);
                            break;
                          case 'imprimir_frequencia':
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AttendancePage(
                                    students: studentsSelecteds,
                                    itinerary: itinerary)));
                            break;
                        }
                      },
                    )
                  ]
                : school == null &&
                        (userType == UserType.admin ||
                            userType == UserType.coordinator)
                    ? [
                        PopupMenuButton(
                          itemBuilder: ((context) => [
                                const PopupMenuItem(
                                    value: 'manager_monitor',
                                    child: Text('Gerenciar monitora')),
                                const PopupMenuItem(
                                    value: 'frequencia',
                                    child: Text('Ir para lista de frequência')),
                              ]),
                          onSelected: (value) {
                            switch (value) {
                              case 'frequencia':
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AttendancePage(
                                        students: studentsSelecteds,
                                        itinerary: itinerary)));
                                break;
                              case 'manager_monitor':
                                Navigator.of(context).pushNamed(
                                    Constants
                                        .kUSERMONITORASFORITINERARYLISTROUTE,
                                    arguments: itinerary);
                                break;
                            }
                          },
                        )
                      ]
                    : userType == UserType.schoolMember
                        ? [
                            PopupMenuButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              itemBuilder: ((context) => [
                                    const PopupMenuItem(
                                        value: 'add_studente',
                                        child: Text('Adicionar estudante')),
                                    const PopupMenuItem(
                                        value: 'imprimir_frequencia',
                                        child: Text(
                                            'Ir para lista de frequência')),
                                  ]),
                              onSelected: (value) {
                                switch (value) {
                                  case 'add_studente':
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StudentsAddItineraryForSchoollList(
                                                  school: school!,
                                                  itinerary: itinerary,
                                                )));
                                    break;

                                  case 'imprimir_frequencia':
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AttendancePage(
                                                    students: studentsSelecteds,
                                                    itinerary: itinerary)));
                                    break;
                                }
                              },
                            )
                          ]
                        : userType == UserType.coordinator
                            ? [
                                PopupMenuButton(
                                  itemBuilder: ((context) => [
                                        const PopupMenuItem(
                                            value: 'manager_monitor',
                                            child: Text('Gerenciar monitora')),
                                        const PopupMenuItem(
                                            value: 'frequencia',
                                            child: Text(
                                                'Ir para lista de frequência')),
                                      ]),
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'frequencia':
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AttendancePage(
                                                        students:
                                                            studentsSelecteds,
                                                        itinerary: itinerary)));
                                        break;
                                      case 'manager_monitor':
                                        Navigator.of(context).pushNamed(
                                            Constants
                                                .kUSERMONITORASFORITINERARYLISTROUTE,
                                            arguments: itinerary);
                                        break;
                                    }
                                  },
                                )
                              ]
                            : [
                                PopupMenuButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  itemBuilder: ((context) => [
                                        const PopupMenuItem(
                                            value: 'imprimir_frequencia',
                                            child: Text(
                                                'Ir para lista de frequência')),
                                      ]),
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'imprimir_frequencia':
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AttendancePage(
                                                        students:
                                                            studentsSelecteds,
                                                        itinerary: itinerary)));
                                        break;
                                      case 'faltosos':
                                    }
                                  },
                                )
                              ]),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder<List<Student>>(
                future: context
                    .read<StudentProvider>()
                    .getStudentsByItinerary(itinerary.id!),
                builder: (context, snapshot) {
                  studentProvider.getStudentsByItinerary(itinerary.id!);
                  vacances =
                      itinerary.capacity - studentProvider.students.length;
                  studentsSelecteds = studentProvider.students
                      .where((student) => student.authorized == true)
                      .toList();

                  if (studentsSelecteds.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MonitoringButtons(itineraryId: itinerary.id!),
                        Text('Código: ${itinerary.code}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Consumer2<ItineraryProvider, AppUserProvider>(builder:
                            (context, itineraryProvider, appUserProvider,
                                child) {
                          appUserProvider.getMonitora(itinerary.appUserId);

                          var monitora = appUserProvider.typeUser;
                          if (monitora == null) {
                            return const Text(
                              'Monitora: Não cadastrada',
                              style: TextStyle(fontSize: 18),
                            );
                          }
                          return Text('Monitora: ${monitora.name},',
                              style: const TextStyle(fontSize: 18));
                        }),
                        Text('Motorista: ${itinerary.driverName}',
                            style: const TextStyle(fontSize: 18)),
                        Text('Placa do veículo: ${itinerary.vehiclePlate}',
                            style: const TextStyle(fontSize: 18)),
                        Text('Itinerário: ${itinerary.trajectory}',
                            style: const TextStyle(fontSize: 18)),
                        Text('Tipo: ${itinerary.type.value}',
                            style: const TextStyle(fontSize: 18)),
                        Text('Vagas disponíveis: $vacances',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          vacances == 0
                              ? 'Nenhum estudante cadastrado.'
                              : 'Nenhum estudante aprovado.',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MonitoringButtons(itineraryId: itinerary.id!),
                      Text('Código: ${itinerary.code}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Consumer2<ItineraryProvider, AppUserProvider>(builder:
                          (context, itineraryProvider, appUserProvider, child) {
                        appUserProvider.getMonitora(itinerary.appUserId);

                        var monitora = appUserProvider.typeUser;

                        if (monitora == null) {
                          return const Text(
                            'Monitora: Não cadastrada',
                            style: TextStyle(fontSize: 18),
                          );
                        }
                        // print('monitora: ${monitora.cpf}');
                        return Text('Monitora: ${monitora.name}',
                            style: const TextStyle(fontSize: 18));
                      }),
                      Text('Motorista: ${itinerary.driverName}',
                          style: const TextStyle(fontSize: 18)),
                      Text('Placa do veículo: ${itinerary.vehiclePlate}',
                          style: const TextStyle(fontSize: 18)),
                      Text('Itinerário: ${itinerary.trajectory}',
                          style: const TextStyle(fontSize: 18)),
                      Text('Tipo: ${itinerary.type.value}',
                          style: const TextStyle(fontSize: 18)),
                      Text('Vagas disponíveis: $vacances',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Flexible(
                        child: ListView.builder(
                          itemCount: studentsSelecteds.length,
                          itemBuilder: (context, index) {
                            studentsSelecteds.sort((a, b) => a.name
                                .toLowerCase()
                                .compareTo(b.name.toLowerCase()));
                            final student = studentsSelecteds[index];

                            return InkWell(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => StudentDetailsPage(
                                          student: student))),
                              onLongPress: userType != UserType.monitor
                                  ? () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Remover estudante'),
                                            content: const Text(
                                                'Deseja remover o estudante do itinerário?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  context
                                                      .read<ItineraryProvider>()
                                                      .removeStudentFromItinerary(
                                                          itineraryId:
                                                              itinerary.id!,
                                                          studentId:
                                                              student.id!);
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Remover'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  : () {
                                      _deleteFaltas(
                                          context, studentProvider, student);
                                    },
                              child: StudentCard(student: student),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              )),
        ));
  }

  Future<dynamic> _deleteFaltas(
      BuildContext context, StudentProvider studentProvider, Student student) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gerenciar faltas'),
          content: const Text('Atenção! Esta ação não poderá ser desfeita.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Tirar uma falta'),
              onPressed: () {
                studentProvider.subtractOneAbsence(student.id!);

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Zerar faltas'),
              onPressed: () {
                studentProvider.resetAbsences(student.id!);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
