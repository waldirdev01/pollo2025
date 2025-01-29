import 'package:flutter/material.dart';

import '../../modules/itinerary/widgets/monitoring_buttons.dart';

class CustomDrawer extends StatelessWidget {
  final String itineraryId;

  const CustomDrawer({super.key, required this.itineraryId});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 111, 94, 203), // Cor sólida
            ),
            child: Center(
              child: Text(
                'Menu de Monitoramento',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MonitoringButtons(itineraryId: itineraryId),
            ),
          ),
        ],
      ),
    );
  }
}
