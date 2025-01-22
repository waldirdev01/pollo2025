import 'package:flutter/material.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/core/widgets/custom_home_card.dart';

import '../../../../core/constants/constants.dart';

class DataHome extends StatelessWidget {
  const DataHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Selecionar relatório',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 1,
          children: [
            CustomHomeCard(
                icon: Icons.directions_bus,
                text: 'Dados do transporte',
                onTap: () =>
                    Navigator.pushNamed(context, Constants.kCOMPANYANALITICS)),
            CustomHomeCard(
              icon: Icons.assessment,
              text: 'Quadro de itinerários',
              onTap: () =>
                  Navigator.pushNamed(context, Constants.kGENERATEDFORPAYMENT),
            ),
          ],
        ),
      ),
    );
  }
}
