import 'package:flutter/material.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/app_user.dart';
import 'package:provider/provider.dart';

import '../core/widgets/custom_home_card.dart';
import '../providers/app_auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //StudentProvider studentProvider = context.read<StudentProvider>();
    //studentProvider.getStudentsWithCpfNot11Characters();
    final appUser = context.read<AppAuthProvider>().appUser;
    return Scaffold(
      appBar: CustomAppBar(
        title: Constants.kCOMPANYNAME,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AppAuthProvider>().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Constants.kUSERLOGINROUTE, (route) => false);
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: appUser?.type != UserType.admin
              ? [
                  CustomHomeCard(
                    icon: Icons.list_alt,
                    text: 'Todas as Escolas',
                    onTap: () {
                      Navigator.pushNamed(context, Constants.kSCHOOLLISTROUTE);
                    },
                  ),
                  CustomHomeCard(
                    icon: Icons.route,
                    text: 'Cadastrar Itinerário',
                    onTap: () {
                      Navigator.pushNamed(
                          context, Constants.kITINERARYCREATEROUTE);
                    },
                  ),
                  CustomHomeCard(
                    icon: Icons.list_alt,
                    text: 'Todos os Itinerários',
                    onTap: () {
                      Navigator.pushNamed(
                          context, Constants.kITINERARYLISTROUTE);
                    },
                  ),
                  CustomHomeCard(
                    icon: Icons.school,
                    text: 'Alunos pelo nome',
                    onTap: () {
                      Navigator.pushNamed(
                          context, Constants.kSTUDENTBYNAMEROUTE);
                    },
                  ),
                  CustomHomeCard(
                      icon: Icons.analytics_outlined,
                      text: 'Relatórios',
                      onTap: () =>
                          Navigator.pushNamed(context, Constants.kDATAHOME)),
                ]
              : [
                  CustomHomeCard(
                    icon: Icons.account_balance,
                    text: 'Cadastrar Escola',
                    onTap: () {
                      Navigator.pushNamed(
                          context, Constants.kSCHOOLCREATEROUTE);
                    },
                  ),
                  CustomHomeCard(
                    icon: Icons.list_alt,
                    text: 'Todas as Escolas',
                    onTap: () {
                      Navigator.pushNamed(context, Constants.kSCHOOLLISTROUTE);
                    },
                  ),
                  CustomHomeCard(
                    icon: Icons.add_road,
                    text: 'Cadastrar Itinerário',
                    onTap: () {
                      Navigator.pushNamed(
                          context, Constants.kITINERARYCREATEROUTE);
                    },
                  ),
                  CustomHomeCard(
                    icon: Icons.list_alt,
                    text: 'Todos os Itinerários',
                    onTap: () {
                      Navigator.pushNamed(
                          context, Constants.kITINERARYLISTROUTE);
                    },
                  ),
                  CustomHomeCard(
                    icon: Icons.school,
                    text: 'Alunos pelo nome',
                    onTap: () {
                      Navigator.pushNamed(
                          context, Constants.kSTUDENTBYNAMEROUTE);
                    },
                  ),
                  CustomHomeCard(
                      icon: Icons.manage_accounts,
                      text: 'Gerenciar Usuários',
                      onTap: () => Navigator.pushNamed(
                          context, Constants.kUSERMANAGEUSERTYPEROUTE)),
                  CustomHomeCard(
                      icon: Icons.analytics_outlined,
                      text: 'Relatórios',
                      onTap: () =>
                          Navigator.pushNamed(context, Constants.kDATAHOME)),
                  CustomHomeCard(
                      icon: Icons.checklist,
                      text: 'Alunos para aprovar',
                      onTap: () => Navigator.pushNamed(
                          context, Constants.kSTUDENTSFORAUTHORIZE)),
                ],
        ),
      ),
    );
  }
}
