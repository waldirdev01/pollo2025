import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/school.dart';
import 'package:pollo2025/app/modules/school/widgets/school_card_list.dart';
import 'package:pollo2025/app/providers/app_auth_provider.dart';
import 'package:pollo2025/app/providers/school_provider.dart';

class SchoolList extends StatelessWidget {
  const SchoolList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Escolas Cadastradas',
      ),
      body: FutureBuilder<List<School>>(
        future: context.watch<SchoolProvider>().getSchools(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar escolas: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final schools = snapshot.data;
            return ListView.builder(
              itemCount: schools!.length,
              itemBuilder: (context, index) {
                final school = schools[index];
                return SchoolCardList(
                    school: school,
                    schoolProvider: context.read<SchoolProvider>(),
                    currentUserType:
                        context.read<AppAuthProvider>().currentUserType);
              },
            );
          }
          return const Center(child: Text('Nenhuma escola cadastrada'));
        },
      ),
    );
  }
}
