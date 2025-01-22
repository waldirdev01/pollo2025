import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/providers/app_auth_provider.dart';
import 'package:pollo2025/app/providers/school_provider.dart';

class SchoolMemberHomePage extends StatelessWidget {
  const SchoolMemberHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appAuthProvider = context.read<AppAuthProvider>();
    final appUser = appAuthProvider.appUser;

    if (appUser != null) {
      // Somente tenta carregar a escola se appUser não for null
      context.read<SchoolProvider>().getSchoolByAppUserId(appUser.id);
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sua escola',
        actions: [
          IconButton.filled(
              onPressed: () {
                appAuthProvider.logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Constants.kUSERLOGINROUTE, (route) => false);
              },
              icon: const Icon(
                Icons.exit_to_app_sharp,
                color: Colors.white,
              ))
        ],
      ),
      body: Center(child: Consumer<SchoolProvider>(
        builder: (context, schoolProvider, child) {
          final school = schoolProvider.school;
          return schoolProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : school == null
                  ? const Text('Nenhuma escola encontrada')
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: AppUiConfig.themeCustom.primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  school.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Telefone: ${school.phone}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => Navigator.pushNamed(
                              context, Constants.kSCHOOLDETAILSROUTE,
                              arguments: school),
                        ),
                      ],
                    );
        },
      )),
    );
  }
}
