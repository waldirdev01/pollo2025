import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/app_user.dart';
import 'package:pollo2025/app/models/school.dart';
import 'package:pollo2025/app/providers/app_auth_provider.dart';

import 'e_c_list_for_school.dart';

class ExtracurricularActivityHome extends StatelessWidget {
  const ExtracurricularActivityHome({super.key});

  @override
  Widget build(BuildContext context) {
    final appUser = context.read<AppAuthProvider>().appUser;
    final school = ModalRoute.of(context)!.settings.arguments as School;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Atividade Extracurricular',
      ),
      body: Container(
        margin: const EdgeInsets.all(2),
        child: Column(
          children: [
            Card(
              color: appUser?.type == UserType.coordinator
                  ? Colors.grey
                  : AppUiConfig.themeCustom.primaryColor,
              child: ListTile(
                title: const Text(
                  'Criar Atividade',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                trailing:
                    const Icon(Icons.add_to_queue_sharp, color: Colors.white),
                onTap: appUser?.type == UserType.coordinator
                    ? null
                    : () {
                        Navigator.of(context).pushNamed(
                          Constants.kEXTRACURRICULARACTIVITYCREATEROUTE,
                          arguments: school,
                        );
                      },
              ),
            ),
            Card(
              color: AppUiConfig.themeCustom.primaryColor,
              child: ListTile(
                title: const Text(
                  'Ver Atividades Cadastradas',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.list, color: Colors.white),
                onTap: appUser?.type != UserType.schoolMember
                    ? () {
                        Navigator.of(context).pushNamed(
                            Constants.kEXTRACURRICULARACTIVITYLISTROUTE);
                      }
                    : () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  ECListForSchool(school: school)),
                        ),
              ),
            ),
            Card(
              color: appUser?.type == UserType.coordinator
                  ? Colors.grey
                  : AppUiConfig.themeCustom.primaryColor,
              child: ListTile(
                title: const Text(
                  'Cadastrar Estudante',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.person_add, color: Colors.white),
                onTap: appUser?.type == UserType.coordinator
                    ? null
                    : () {
                        Navigator.pushNamed(
                          context,
                          Constants.kECSTUDENTCREATEROUTE,
                          arguments: school.id,
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
