import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pollo2025/app/core/widgets/custom_app_bar.dart';
import 'package:pollo2025/app/modules/itinerary/widgets/itinerary_card_list.dart';
import 'package:pollo2025/app/providers/itinerary_provider.dart';

import '../../core/ui/ap_ui_config.dart';
import '../../models/itinerary.dart';
import '../../models/school.dart';
import 'itineraries_route.dart';

class ItinerariesBySchoolList extends StatelessWidget {
  const ItinerariesBySchoolList({super.key});

  Future<void> _printRoutes(
      {required List<Itinerary> itineraries,
      required BuildContext context}) async {
    Future<Uint8List> Function(PdfPageFormat) buildPdf;

    // Função para gerar o PDF
    buildPdf = (PdfPageFormat format) async {
      final pdf = PDFGeneratorTrajectory.generatePDF(itineraries);

      // Retornar o documento em formato de bytes para ser impresso
      return pdf.save();
    };

    // Chamar o Printing para exibir o layout do PDF
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text('Quadro de Pagamento Gerado.'),
          ),
          body: PdfPreview(
            build: buildPdf,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final school = ModalRoute.of(context)!.settings.arguments as School;

    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Itinerários da escola',
        ),
        body: FutureBuilder(
          future: context
              .watch<ItineraryProvider>()
              .getItinerariesBySchool(school.id!),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro: ${snapshot.error}'),
                  );
                }
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final itineraries = snapshot.data!;
                  itineraries.sort((a, b) => a.code.compareTo(b.code));

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: itineraries.length,
                          itemBuilder: (context, index) {
                            final itinerary = itineraries[index];
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ItineraryCardList(
                                  itinerary: itinerary, school: school),
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppUiConfig.themeCustom.primaryColor),
                          onPressed: () => _printRoutes(
                              itineraries: itineraries, context: context),
                          child: const Text(
                            'Imprimir rotas',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    ],
                  );
                }

                return const Center(
                  child: Text(
                    'Nenhum itinerário associado à escola.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
            }
          },
        ));
  }
}
