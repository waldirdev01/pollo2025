import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/itinerary.dart';
import '../../../models/school.dart';
import '../../../providers/app_user_provider.dart';

class ItineraryHeader extends StatelessWidget {
  final Itinerary itinerary;
  final School? school;

  const ItineraryHeader({
    super.key,
    required this.itinerary,
    this.school,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Código: ${itinerary.code}', style: _headerStyle()),
        Consumer<AppUserProvider>(
          builder: (context, appUserProvider, child) {
            appUserProvider.getMonitora(itinerary.appUserId);
            final monitora = appUserProvider.typeUser;
            return Text(
              'Monitora: ${monitora?.name ?? "Não cadastrada"}',
              style: _headerStyle(),
            );
          },
        ),
        Text('Motorista: ${itinerary.driverName}', style: _headerStyle()),
        Text('Placa do veículo: ${itinerary.vehiclePlate}',
            style: _headerStyle()),
        Text('Itinerário: ${itinerary.trajectory}', style: _headerStyle()),
        Text('Tipo: ${itinerary.type.value}', style: _headerStyle()),
      ],
    );
  }

  TextStyle _headerStyle() {
    return const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  }
}
