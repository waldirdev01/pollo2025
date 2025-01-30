import 'package:flutter/material.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/modules/itinerary/itinerary_details_page.dart';
import 'package:pollo2025/app/providers/app_auth_provider.dart';
import 'package:pollo2025/app/providers/itinerary_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/app_user.dart';
import 'ec_monitor_page.dart';

class MonitorHomePage extends StatelessWidget {
  const MonitorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final monitora = ModalRoute.of(context)!.settings.arguments as AppUser;

    return Scaffold(
        appBar: CustomAppBar(
          title: 'Seus itinerários',
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
            future: context
                .read<ItineraryProvider>()
                .getItineraryByAppUserId(monitora.id),
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
                final itineraries = snapshot.data!;
                return ListView.builder(
                  itemCount: itineraries.length,
                  itemBuilder: (context, index) {
                    final itinerary = itineraries[index];
                    return Card(
                      color: AppUiConfig.themeCustom.primaryColor,
                      child: ListTile(
                        title: Text(itinerary.code,
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(itinerary.trajectory,
                            style: const TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ItineraryDetailsPage(itinerary: itinerary)));
                        },
                      ),
                    );
                  },
                );
              }
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppUiConfig.themeCustom.primaryColor,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ECMonitorPage(
                      id: monitora.id,
                    )));
          },
          child: const Icon(Icons.explicit, color: Colors.white),
        ));
  }
}
