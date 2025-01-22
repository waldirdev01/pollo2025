import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/school.dart';
import 'package:pollo2025/app/providers/app_user_provider.dart';
import 'package:pollo2025/app/providers/school_provider.dart';

class SchoolMemberList extends StatelessWidget {
  const SchoolMemberList({super.key});

  @override
  Widget build(BuildContext context) {
    final school = ModalRoute.of(context)!.settings.arguments as School;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Usuários de escolas',
      ),
      body: Consumer2<AppUserProvider, SchoolProvider>(
        builder: (context, appUserProvider, schoolProvider, child) {
          // Obter os usuários da escola
          appUserProvider.getAppUsersByType('schoolMember');
          final appUsers = appUserProvider.appUsers;

          // Obter a escola
          schoolProvider.getSchool(school.id!);

          return schoolProvider.school != null
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: ListView.builder(
                    itemCount: appUsers.length,
                    itemBuilder: (context, index) {
                      final appUser = appUsers[index];
                      return Card(
                        color: schoolProvider.school!.appUserId!
                                .contains(appUser.id)
                            ? Colors.greenAccent.shade100
                            : Colors.grey.shade100,
                        child: Row(
                          children: [
                            Flexible(
                              child: ListTile(
                                leading: const Icon(Icons.school),
                                title: Text(appUser.name),
                                subtitle: Text(appUser.email),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    schoolProvider.addAppUserToSchool(
                                        schoolId: school.id!,
                                        appUserId: appUser.id);
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  schoolProvider.removeAppUserToSchool(
                                      schoolId: school.id!,
                                      appUserId: appUser.id);
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const Center(child: Text('Carregando...'));
        },
      ),
    );
  }
}
