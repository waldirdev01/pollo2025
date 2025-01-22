import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../../../core/ui/ap_ui_config.dart';
import '../../../../models/for_payment.dart';
import '../../../../providers/for_payment_provider.dart';
import '../widgets/for_payment_card.dart';
import 'for_payment_report.dart';

class GenerateForPayment extends StatefulWidget {
  const GenerateForPayment({super.key});

  @override
  State<GenerateForPayment> createState() => _GenerateForPaymentState();
}

class _GenerateForPaymentState extends State<GenerateForPayment> {
  final DateTime _selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  String _contract = '20/2022';
  List<ForPayment> forPayments = [];
  bool _cangenerate = false;
  double _contractValue = 0;
  bool _isLoading = false;

  final _valorEC = TextEditingController();

// Usando ValueNotifier para melhor desempenho
  final ValueNotifier<DateTime> _selectedDateNotifier =
      ValueNotifier(DateTime.now());

  Future<void> _selectDate(BuildContext context) async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDateNotifier.value,
        firstDate: DateTime(2023),
        lastDate: DateTime(2028),
      );
      if (picked != null && picked != _selectedDateNotifier.value) {
        _selectedDateNotifier.value = picked;
      }
    } catch (e) {
      debugPrint("Erro ao selecionar data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Gerar Fatura de Pagamento'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _valorEC,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        labelText: 'Valor do quilômetros rodado',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor insira um valor';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      value: _contract,
                      decoration: const InputDecoration(
                        labelText: 'Contrato',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      items: <String>[
                        '12/2024',
                        '20/2022',
                        '02/2023',
                        '63/2021',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _contract = value!;
                        });
                      },
                    ),
                  ),
                  _cangenerate
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: AppUiConfig.elevatedButtonThemeCustom,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                _contractValue = double.parse(_valorEC.text);

                                context
                                    .read<ForPaymentProvider>()
                                    .generateForPaymentMonth(
                                      monthYear: _selectedDate,
                                      contract: _contract,
                                      valor: _contractValue,
                                    )
                                    .then((_) {
                                  setState(() {
                                    _isLoading = false;
                                    _cangenerate = false;
                                  });
                                });
                              }
                            },
                            child: const Text(
                              'Gerar Quadro de Pagamento',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: AppUiConfig.elevatedButtonThemeCustom,
                            onPressed: () {
                              context
                                  .read<ForPaymentProvider>()
                                  .clearForPayment();
                              setState(() {
                                _cangenerate = true;
                              });
                            },
                            child: const Text(
                              'Limpar Dados',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          Flexible(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Consumer<ForPaymentProvider>(
                    builder: (context, forPaymentProvider, child) {
                      forPaymentProvider.getForPayimentList(
                        contract: _contract,
                        month: _selectedDate,
                      );
                      forPayments = forPaymentProvider.forPayments;
                      return ListView.builder(
                        itemCount: forPayments.length,
                        itemBuilder: (context, index) {
                          return ForPaymentCard(
                            forPayment: forPaymentProvider.forPayments[index],
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppUiConfig.themeCustom.primaryColor,
        onPressed: !_cangenerate
            ? () => _previewPdf(
                _selectedDate.month, forPayments, _contract, _contractValue)
            : null,
        child: const Icon(Icons.print, color: Colors.white),
      ),
    );
  }

  Future<void> _previewPdf(
    int month,
    List<ForPayment> forPayments,
    String contract,
    double contractValue,
  ) async {
    Future<Uint8List> Function(PdfPageFormat) buildPdf;

    buildPdf =
        (format) async => await ForPaymentReport.generateForPaymentReport(
              forPayments: forPayments,
              contract: contract,
              contractValue: contractValue,
            );

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
}
