import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pollo2025/app/core/ui/ap_ui_config.dart';

import '../../../../models/for_payment.dart';

class ForPaymentCard extends StatelessWidget {
  const ForPaymentCard({super.key, required this.forPayment});
  final ForPayment forPayment;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppUiConfig.themeCustom.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contrato: ${forPayment.contract}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Data: ${DateFormat('dd/MM/yyyy').format(forPayment.dateOfEvent)}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Itinerário: ${forPayment.itinerarieCode}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Turno: ${forPayment.itinerariesShift}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Escolas: ${forPayment.schoolsName.join(', ')}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Trajeto: ${forPayment.trajectory}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
