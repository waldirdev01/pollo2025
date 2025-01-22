import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/modules/app_user/admin/widgets/user_card_selector_type.dart';
import 'package:pollo2025/app/providers/app_user_provider.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../../../models/app_user.dart';

class ManagerUsersType extends StatelessWidget {
  const ManagerUsersType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gerenciar usuários'),
      body: FutureBuilder<List<AppUser>>(
          future: context.watch<AppUserProvider>().getAppUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Caso esteja carregando os dados, você pode exibir um indicador de progresso.
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Caso ocorra um erro durante o carregamento dos dados.
              return Center(
                child: Text('Erro ao carregar usuários: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Caso não haja dados ou os dados estejam vazios.
              return const Center(
                child: Text('Nenhum usuário cadastrado'),
              );
            } else {
              // Caso os dados tenham sido carregados com sucesso.
              final users = snapshot.data!;
              users.sort((a, b) => a.name.compareTo(b.name));
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final appUser = users[index];
                  return UserCardSelectType(
                    appUser: appUser,
                    appUserProvider: context.read<AppUserProvider>(),
                  );
                },
              );
            }
          }),
    );
  }
}
