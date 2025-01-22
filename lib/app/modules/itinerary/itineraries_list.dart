import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/models/itinerary.dart';
import 'package:pollo2025/app/models/school.dart';
import 'package:pollo2025/app/modules/itinerary/widgets/itinerary_card_list.dart';
import 'package:pollo2025/app/providers/itinerary_provider.dart';

class ItinerariesList extends StatelessWidget {
  const ItinerariesList({super.key});

  @override
  Widget build(BuildContext context) {
    final school = ModalRoute.of(context)!.settings.arguments as School?;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Itinerários Cadastrados'),
      body: FutureBuilder<List<Itinerary>>(
          future: context.watch<ItineraryProvider>().getItineraries(),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                    child: Text('Erro ao carregar itinerários'));
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData) {
                  final List<Itinerary> itineraries = snapshot.data!;
                  itineraries.sort((a, b) => a.code.compareTo(b.code));
                  return ListView.builder(
                    itemCount: itineraries.length,
                    itemBuilder: (context, index) {
                      final Itinerary itinerary = itineraries[index];
                      //print('cod: ${itinerary.code}, contract: ${itinerary.contract}');
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ItineraryCardList(
                          itinerary: itinerary,
                          school: school,
                        ),
                      );
                    },
                  );
                }
                return const Center(
                    child: Text('Nenhum itinerário cadastrado'));
            }
          })),
    );
  }
}
