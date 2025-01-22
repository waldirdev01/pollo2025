import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/app_user.dart';
import 'package:pollo2025/app/models/itinerary.dart';
import 'package:pollo2025/app/providers/app_user_provider.dart';
import 'package:pollo2025/app/providers/itinerary_provider.dart';

class MonitorForItineraryList extends StatelessWidget {
  const MonitorForItineraryList({super.key});

  @override
  Widget build(BuildContext context) {
    final itinerary = ModalRoute.of(context)!.settings.arguments as Itinerary;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Monitoras',
      ),
      body: FutureBuilder(
          future: context.read<AppUserProvider>().getAppUsers(),
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
                child: Text('Nenhuma monitora cadastrada'),
              );
            } else {
              // Caso os dados tenham sido carregados com sucesso.

              final users = snapshot.data!;
              final monitoras = users
                  .where((user) =>
                      user.type.toString() == UserType.monitor.toString())
                  .toList();
              monitoras.sort((a, b) => a.name.compareTo(b.name));
              return ListView.builder(
                itemCount: monitoras.length,
                itemBuilder: (context, index) {
                  final monitora = monitoras[index];
                  return Consumer<ItineraryProvider>(
                      builder: (builder, itinerayProvider, child) {
                    itinerayProvider.getItinerary(itinerary.id!);
                    var itineraryLoaded = itinerayProvider.itinerary;
                    if (itineraryLoaded == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Card(
                        color: monitora.id == itineraryLoaded.appUserId
                            ? Colors.greenAccent.shade100
                            : Colors.grey.shade100,
                        child: ListTile(
                          title: Text(monitora.name),
                          subtitle: Text(monitora.email),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              itinerayProvider.addMonitorToItinerary(
                                  itineraryId: itineraryLoaded.id!,
                                  monitorId: monitora.id);
                            },
                          ),
                        ),
                      ),
                    );
                  });
                },
              );
            }
          }),
    );
  }
}
