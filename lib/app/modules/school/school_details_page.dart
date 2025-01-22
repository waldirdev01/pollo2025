import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/models/app_user.dart';
import 'package:pollo2025/app/modules/school/school_data.dart';
import 'package:pollo2025/app/providers/app_auth_provider.dart';

import '../../core/ui/ap_ui_config.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../models/school.dart';
import '../student/students_by_school_has_incidents.dart';

class SchoolDetailsPage extends StatelessWidget {
  const SchoolDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final school = ModalRoute.of(context)!.settings.arguments as School;
    final appUser = context.read<AppAuthProvider>().appUser;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Dados da Escola'),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppUiConfig.themeCustom.primaryColor,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Icon(Icons.menu, color: Colors.white, size: 80),
                ],
              ),
            ),
            appUser?.type == UserType.coordinator
                ? const SizedBox.shrink()
                : Card(
                    color: AppUiConfig.themeCustom.primaryColor,
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          Constants.kSTUDENTCREATEROUTE,
                          arguments: school,
                        );
                      },
                      title: const Text('Adicionar Aluno',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      trailing:
                          const Icon(Icons.person_add, color: Colors.white),
                    ),
                  ),
            const SizedBox(),
            Card(
              color: AppUiConfig.themeCustom.primaryColor,
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          StudentsBySchoolHasIncidents(school: school)));
                },
                title: const Text('Verificar incidentes',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                trailing: const Icon(Icons.warning, color: Colors.white),
              ),
            ),
            const SizedBox(),
            Card(
              color: AppUiConfig.themeCustom.primaryColor,
              child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      Constants.kITINERARIESBYSCHOOLROUTE,
                      arguments: school,
                    );
                  },
                  title: const Text('Ver itinerários da escola',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  trailing:
                      const Icon(Icons.directions_bus, color: Colors.white)),
            ),
            const SizedBox(),
            appUser?.type == UserType.admin
                ? Card(
                    color: AppUiConfig.themeCustom.primaryColor,
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          Constants.kSCHOOLMEMBERSLISTROUTE,
                          arguments: school,
                        );
                      },
                      title: const Text('Adcionar Usuário à Escola',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      trailing:
                          const Icon(Icons.person_add, color: Colors.white),
                    ),
                  )
                : appUser?.type == UserType.coordinator
                    ? const SizedBox.shrink()
                    : Card(
                        color: AppUiConfig.themeCustom.primaryColor,
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              Constants.kSCHOOLEDITROUTE,
                              arguments: school,
                            );
                          },
                          title: const Text('Editar dados da escola',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          trailing: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
            const SizedBox(),
            Card(
              color: AppUiConfig.themeCustom.primaryColor,
              child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SchoolData(school: school)));
                  },
                  title: const Text('Mais informações',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  trailing: const Icon(Icons.info, color: Colors.white)),
            ),
            appUser?.type == UserType.schoolMember
                ? const SizedBox.shrink()
                : Card(
                    color: AppUiConfig.themeCustom.primaryColor,
                    child: ListTile(
                      title: const Text(
                        'Adicionar Itinerário',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          Constants.kITINERARYLISTROUTE,
                          arguments: school,
                        );
                      },
                      trailing: const Icon(Icons.add_road_outlined,
                          color: Colors.white),
                    )),
            Card(
              color: AppUiConfig.themeCustom.primaryColor,
              child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        Constants.kEXTRACURRICULARACTIVITYHOMEROUTE,
                        arguments: school);
                  },
                  title: const Text('Atividade Extracurricular',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  trailing: const Icon(Icons.museum, color: Colors.white)),
            ),
            Card(
              color: AppUiConfig.themeCustom.primaryColor,
              child: ListTile(
                title: const Text('Sair do aplicativo',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(alignment: Alignment.bottomCenter, child: AppLogo()),
              const SizedBox(height: 16),
              Text(
                school.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone,
                      color: AppUiConfig.themeCustom.primaryColor),
                  const SizedBox(width: 8),
                  Text(school.phone),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: AppUiConfig.themeCustom.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(children: [
                  const Text(
                    'Equipe Escolar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: AppUiConfig.themeCustom.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(school.principalName),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: AppUiConfig.themeCustom.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(school.secretaryName),
                    ],
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              Text(
                'Código Inep: ${school.inep}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
