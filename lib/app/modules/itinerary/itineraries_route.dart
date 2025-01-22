import 'package:pdf/widgets.dart' as pw;

import '../../models/itinerary.dart';

class PDFGeneratorTrajectory {
  static pw.Document generatePDF(List<Itinerary> itineraries) {
    final pdf = pw.Document();

    // Adicionar as páginas ao PDF usando pw.MultiPage para lidar com a quebra automática de página
    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          // Criar uma lista de widgets para todos os itinerários
          List<pw.Widget> itineraryWidgets = [];

          if (itineraries.isNotEmpty) {
            // Adicionar widgets para cada itinerário
            for (var itinerary in itineraries) {
              itineraryWidgets.add(
                pw.Column(
                  children: [
                    pw.Text('Código: ${itinerary.code}',
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.Text('Trajeto: ${itinerary.trajectory}',
                        textAlign: pw.TextAlign.justify,
                        style: const pw.TextStyle(fontSize: 16)),
                    pw.SizedBox(height: 10),
                    pw.Text(
                        '*______________________________________________________________________*\n\n'),
                  ],
                ),
              );
            }
          } else {
            // Caso a lista esteja vazia, adicionar um texto informando
            itineraryWidgets.add(
              pw.Text('Nenhum itinerário encontrado'),
            );
          }

          // Retornar os widgets; o MultiPage vai lidar com a quebra de página automática
          return itineraryWidgets;
        },
      ),
    );

    return pdf;
  }
}
