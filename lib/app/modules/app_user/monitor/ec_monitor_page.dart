import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/extracurricular_activity.dart';
import 'package:pollo2025/app/modules/extracurricular_activity/activities/e_c_details_page.dart';
import 'package:pollo2025/app/providers/e_c_activity_provider.dart';
import '../../../providers/app_auth_provider.dart';

// ignore: must_be_immutable
class ECMonitorPage extends StatelessWidget {
  ECMonitorPage({super.key, required this.id});
  final String id;
  ExtracurricularActivity? ecActivity;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Suas atividades extracurriculares',
          actions: [
            IconButton(
                onPressed: () {
                  context.read<AppAuthProvider>().logout();
                  Navigator.of(context).pushReplacementNamed('/');
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: FutureBuilder(
            future:
                context.read<ECActivityProvider>().getEcActivityByMonitorId(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Caso esteja carregando os dados, você pode exibir um indicador de progresso.
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Caso ocorra um erro durante o carregamento dos dados.
                return Center(
                  child:
                      Text('Erro ao carregar itinerários: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // Caso não haja dados ou os dados estejam vazios.
                return const Center(
                  child: Text('Nenhum itinerário cadastrado'),
                );
              } else {
                // Caso os dados tenham sido carregados com sucesso.
                final exActvities = snapshot.data!;
                return ListView.builder(
                  itemCount: exActvities.length,
                  itemBuilder: (context, index) {
                    ecActivity = exActvities[index];
                    return Card(
                      color: AppUiConfig.themeCustom.primaryColor,
                      child: ListTile(
                        title: Text(
                          ecActivity!.title,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            'Data: ${DateFormat('dd/MM/yyyy').format(ecActivity!.dateOfEvent)}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ECDetailsPage(ecActivity: ecActivity!)));
                        },
                      ),
                    );
                  },
                );
              }
            }));
  }
}
