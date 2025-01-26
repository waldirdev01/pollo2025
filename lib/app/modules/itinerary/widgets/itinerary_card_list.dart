// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pollo2025/app/core/constants/constants.dart';
import 'package:pollo2025/app/models/app_user.dart';
import 'package:pollo2025/app/models/itinerary.dart';
import 'package:pollo2025/app/models/school.dart';
import 'package:pollo2025/app/modules/itinerary/itinerary_details_page.dart';
import 'package:pollo2025/app/providers/app_auth_provider.dart';
import 'package:pollo2025/app/providers/itinerary_provider.dart';
import 'package:provider/provider.dart';

import '../locations/itinerary_map_page.dart';

class ItineraryCardList extends StatelessWidget {
  const ItineraryCardList({super.key, required this.itinerary, this.school});

  final Itinerary itinerary;
  final School? school;

  @override
  Widget build(BuildContext context) {
    final typeUser = context.read<AppAuthProvider>().appUser;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: itinerary.schoolIds!.contains(school?.id!)
            ? Colors.green.shade100
            : Colors.white,
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: typeUser?.type.string == UserType.admin.string ||
              typeUser?.type.string == UserType.coordinator.string
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  itinerary.code,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ItineraryDetailslPage(
                              itinerary: itinerary,
                              school: school,
                            )));
                  },
                  icon: const Icon(Icons.home),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ItineraryMapPage(itineraryId: itinerary.id!),
                    ));
                  },
                  icon: const Icon(Icons.map, color: Colors.blue),
                ),
                school == null
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: () {
                          context
                              .read<ItineraryProvider>()
                              .addSchoolToItinerary(
                                  itineraryId: itinerary.id!,
                                  schoolId: school!.id!);
                        },
                        icon: const Icon(Icons.add),
                      ),
                school == null
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: () {
                          context
                              .read<ItineraryProvider>()
                              .removeSchoolFromItinerary(
                                  itineraryId: itinerary.id!,
                                  schoolId: school!.id!);
                        },
                        icon: const Icon(Icons.remove),
                      ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        Constants.kITINERARYEDITROUTE,
                        arguments: itinerary);
                  },
                  icon: const Icon(Icons.edit),
                ),
                typeUser?.type.string == UserType.coordinator.string
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: () async {
                          await _deleteItinerary(context);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  itinerary.code,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ItineraryCardList(
                              itinerary: itinerary,
                              school: school,
                            )));
                  },
                  icon: const Icon(Icons.home),
                ),
              ],
            ),
    );
  }

  Future<void> _deleteItinerary(BuildContext context) async {
    // Verifique se o itinerário tem alunos ou escolas associadas antes de tentar excluir
    if ((itinerary.studentsId != null && itinerary.studentsId!.isNotEmpty) ||
        (itinerary.schoolIds != null && itinerary.schoolIds!.isNotEmpty)) {
      // Mostre um diálogo de erro em vez de lançar uma exceção
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text(
              'Itinerário não pode ser deletado, pois possui alunos ou escolas vinculadas.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return; // Pare a execução se existirem escolas ou alunos vinculados
    }

    try {
      await context.read<ItineraryProvider>().deleteItinerary(itinerary);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Itinerário ${itinerary.code} excluído com sucesso!'),
      ));
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
          ],
        ),
      );
    }
  }
}
