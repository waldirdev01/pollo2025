import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pollo2025/app/core/constants/constants.dart';
import "package:universal_html/html.dart" as html;

import '../../../../models/for_payment.dart';

class ForPaymentReport {
  static Future<Uint8List> generateForPaymentReport(
      {required List<ForPayment> forPayments,
      required String contract,
      required double contractValue}) async {
    final monthName = DateFormat.MMMM('pt_BR')
        .format(DateTime(2024, forPayments.first.dateOfEvent.month))
        .toUpperCase();

    final pdf = pw.Document();

    int totalSchoolsRural = 0;
    int totalSchoolsUrban = 0;

    int totalStudentsRural = 0;
    int totalStudentsUrban = 0;

    Map<String, int> somaPorNivelETurno = {
      'INFANTIL_MATUTINO': 0,
      'FUNDAMENTAL_MATUTINO': 0,
      'MÉDIO_MATUTINO': 0,
      'INTEGRAL_MATUTINO': 0,
      'ESPECIAL_MATUTINO': 0,
      'EJA_MATUTINO': 0,
      'INFANTIL_VESPERTINO': 0,
      'FUNDAMENTAL_VESPERTINO': 0,
      'MÉDIO_VESPERTINO': 0,
      'INTEGRAL_VESPERTINO': 0,
      'ESPECIAL_VESPERTINO': 0,
      'EJA_VESPERTINO': 0,
      'INFANTIL_NOTURNO': 0,
      'FUNDAMENTAL_NOTURNO': 0,
      'MÉDIO_NOTURNO': 0,
      'INTEGRAL_NOTURNO': 0,
      'ESPECIAL_NOTURNO': 0,
      'EJA_NOTURNO': 0,
    };
    int somaTotalLinha = 0;

    Map<String, int> somaPorTurno = {
      'MATUTINO': 0,
      'VESPERTINO': 0,
      'NOTURNO': 0,
      'INTEGRAL': 0,
      'TOTAL': 0,
    };

    int somaItiMatutino = 0;
    int somaItiVespertino = 0;
    int somaItiNoturno = 0;
    int somaItiIntegral = 0;

    int somaBusMatutino = 0;
    int somaBusVespertino = 0;
    int somaBusNoturno = 0;
    int somaBusIntegral = 0;
    int somaBusTotal = 0;

    int totalItineraries = 0;

    double valorTotalGeral = 0.0;
    double valorInfantil = 0.0;
    double valorFundamental = 0.0;
    double valorMedio = 0.0;
    double valorIntegral = 0.0;
    double valorEspecial = 0.0;
    double valorEja = 0.0;
    double somaKmRegulares = 0.0;
    double somaKmAtividadesDiferenciadas = 0.0;
    double somaKmTotal = 0.0;

    double valorTotalRegular = 0.0;
    double valorTotalAtividadesDiferenciadas = 0.0;

    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    pw.Widget buildHeader(pw.Context context, String monthName) {
      return pw.Column(children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
                'QUADRO DE ITINERÁRIOS - ITAPOA - $monthName/${Constants.kYEAR} - CONTRAT0 ${forPayments.first.contract} - ${Constants.kCOMPANYNAME}',
                textScaleFactor: 1.2,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center),
          ],
        ),
      ]);
    }

    pw.Widget forPaymentTable(pw.Context context, List<ForPayment> payments) {
      List<pw.TableRow> rows = [];

      rows.add(pw.TableRow(
          decoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
          ),
          verticalAlignment: pw.TableCellVerticalAlignment.middle,
          children: [
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text('ITINERÁRIO',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 6)),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text('TURNO',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 6)),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text('ESCOLAS',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 6)),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text('TRAJETO',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 6)),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Column(children: [
                pw.Container(
                  width: 100,
                  height: 25,
                  child: pw.Text('ALUNOS POR MODALIDADE',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 6)),
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(width: 1))),
                ),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        padding: const pw.EdgeInsets.only(right: 2),
                        child: pw.Text('EI',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 5)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        padding: const pw.EdgeInsets.only(right: 2),
                        child: pw.Text('EF',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 5)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        padding: const pw.EdgeInsets.only(right: 2),
                        child: pw.Text('EM',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 5)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        padding: const pw.EdgeInsets.only(right: 2),
                        child: pw.Text('II',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 5)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        padding: const pw.EdgeInsets.only(right: 2),
                        child: pw.Text('EE',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 5)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        padding: const pw.EdgeInsets.only(right: 1),
                        child: pw.Text('EJA',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 5)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        height: 30,
                        alignment: pw.Alignment.bottomCenter,
                        child: pw.Text('TOTAL',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 4)),
                      ),
                    ])
              ]),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Column(children: [
                pw.Container(
                  height: 25,
                  child: pw.Text('PLACAS DOS ÔNIBUS',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 5)),
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(width: 1))),
                ),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        padding: const pw.EdgeInsets.only(right: 1),
                        child: pw.Text('1',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 5)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        padding: const pw.EdgeInsets.only(right: 1),
                        child: pw.Text('2',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 5)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        padding: const pw.EdgeInsets.only(right: 1),
                        child: pw.Text('3',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 5)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        padding: const pw.EdgeInsets.only(right: 1),
                        child: pw.Text('4',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 5)),
                      ),
                    ])
              ]),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Column(children: [
                pw.Container(
                  width: 130,
                  height: 25,
                  child: pw.Text('KM PERCORRIDOS DIARIAMENTE',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 5)),
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(width: 1))),
                ),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        width: 16,
                        padding: const pw.EdgeInsets.only(right: 1),
                        child: pw.Text('KM',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 5)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        width: 8,
                        padding: const pw.EdgeInsets.only(left: 2),
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text('Nº\n\nÔ\nN\nI\nB\nU\nS',
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 3)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        width: 22,
                        padding: const pw.EdgeInsets.only(right: 1),
                        child: pw.Text('KM\n X\n ÔNIBUS',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 4)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        padding: const pw.EdgeInsets.only(right: 1),
                        child: pw.Text('DIAS\n TRABALHADOS',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 3)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        width: 24,
                        child: pw.Text('KM X\nÔNIBUS X\nDIAS\n TRABALHADOS',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 3)),
                      ),
                    ])
              ]),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Column(children: [
                pw.Container(
                  height: 25,
                  width: 130,
                  child: pw.Text('PROFISSIONAIS',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 5)),
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(width: 1))),
                ),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.bottomLeft,
                        height: 30,
                        padding: const pw.EdgeInsets.only(right: 8),
                        child: pw.Text('MOTORISTA',
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 5)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        padding: const pw.EdgeInsets.only(right: 5),
                        child: pw.Text('MONITOR',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 4)),
                      ),
                    ])
              ]),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Column(children: [
                pw.Container(
                  width: 130,
                  height: 25,
                  child: pw.Text('ATIVIDADES DIFERENCIADAS',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 5)),
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(width: 1))),
                ),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        width: 16,
                        padding: const pw.EdgeInsets.only(right: 1),
                        child: pw.Text('KM',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 5)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        width: 8,
                        padding: const pw.EdgeInsets.only(left: 2),
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text('Nº\n\nÔ\nN\nI\nB\nU\nS',
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 3)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        width: 22,
                        padding: const pw.EdgeInsets.only(right: 1),
                        child: pw.Text('KM\n X\n ÔNIBUS',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 4)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        padding: const pw.EdgeInsets.only(right: 1),
                        child: pw.Text('DIAS\n TRABALHADOS',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 3)),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(right: pw.BorderSide(width: 1)),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 30,
                        width: 24,
                        child: pw.Text('KM X\nÔNIBUS X\nDIAS\n TRABALHADOS',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 3)),
                      ),
                    ])
              ]),
            ),
          ]));

      List<ForPayment> regularItineraries = [];
      List<ForPayment> extracurricularActivities = [];
      int quatityBusRegular = 0;
      int quatityBusEc = 0;
      double kmRegular = 0.0;
      double kmEc = 0.0;

      for (ForPayment forPayment in forPayments) {
        if (forPayment.itinerarieCode == 'Atividade Extracurricular') {
          extracurricularActivities.add(forPayment);
        } else {
          regularItineraries.add(forPayment);
        }
      }

      List<ForPayment> allForPayments =
          regularItineraries + extracurricularActivities;
      totalItineraries = allForPayments.length;

      for (ForPayment forPayment in allForPayments) {
        int totalStudents =
            forPayment.levels.values.fold(0, (prev, curr) => prev + curr);

        if (forPayment.itinerarieCode == 'Atividade Extracurricular') {
          quatityBusRegular = 0;
          kmRegular = 0;
          quatityBusEc = forPayment.quantityOfBus;
          kmEc = forPayment.kilometer;
        } else {
          if (forPayment.callDaysRepositionCount > 0) {
            quatityBusRegular = 1;
            quatityBusEc = 1;
            kmEc = forPayment.kilometer;
            kmRegular = forPayment.kilometer;
          } else {
            kmRegular = forPayment.kilometer;
            quatityBusRegular = 1;
            quatityBusEc = 0;
            kmEc = 0;
          }
        }

        double kmXBusRegular = kmRegular * quatityBusRegular;
        double kmXBusEc = kmEc * quatityBusEc;

        double kmXDayXBusRegular =
            kmRegular * quatityBusRegular * forPayment.callDaysCount;

        double kmXDaysXBusEc =
            kmEc * quatityBusEc * forPayment.callDaysRepositionCount;
        somaKmRegulares += kmXDaysXBusEc;
        somaKmAtividadesDiferenciadas += kmXDayXBusRegular;

        totalSchoolsRural += forPayment.schoolsTypeRuralCount;
        totalSchoolsUrban += forPayment.schoolsTypeUrbanCount;

        totalStudentsRural += forPayment.studentsRural;
        totalStudentsUrban += forPayment.studentsUrban;

        if (forPayment.itinerariesShift == 'MATUTINO') {
          somaItiMatutino += 1;
        } else if (forPayment.itinerariesShift == 'VESPERTINO') {
          somaItiVespertino += 1;
        } else if (forPayment.itinerariesShift == 'NOTURNO') {
          somaItiNoturno += 1;
        } else if (forPayment.itinerariesShift == 'INTEGRAL') {
          somaItiIntegral += 1;
        }

        if (forPayment.itinerariesShift == 'MATUTINO') {
          somaBusMatutino += forPayment.quantityOfBus;
        } else if (forPayment.itinerariesShift == 'VESPERTINO') {
          somaBusVespertino += forPayment.quantityOfBus;
        } else if (forPayment.itinerariesShift == 'NOTURNO') {
          somaBusNoturno += forPayment.quantityOfBus;
        } else if (forPayment.itinerariesShift == 'INTEGRAL') {
          somaBusIntegral += forPayment.quantityOfBus;
        }

        for (var key in forPayment.levels.keys) {
          // Calcula o total de alunos por nível de ensino para cada turno
          String nivelTurnoKey = '${key}_${forPayment.itinerariesShift}';

          int alunosNivel = forPayment.levels[key] ?? 0;
          somaPorNivelETurno[nivelTurnoKey] =
              (somaPorNivelETurno[nivelTurnoKey] ?? 0) + alunosNivel;

          // Atualiza a soma total de alunos
          somaTotalLinha += alunosNivel;
        }

        for (var key in forPayment.levels.keys) {
          int alunosNivel = forPayment.levels[key] ?? 0;
          somaPorTurno[forPayment.itinerariesShift] =
              somaPorTurno[forPayment.itinerariesShift]! + alunosNivel;
        }

        pw.Widget cellMode1(String text) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(left: 2),
            child: pw.Text(text,
                textAlign: pw.TextAlign.center,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6)),
          );
        }

        pw.Widget cellMode2(String text) {
          return pw.Container(
            alignment: pw.Alignment.bottomCenter,
            height: 30,
            padding: const pw.EdgeInsets.only(right: 2),
            child: pw.Text(text,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 5)),
            decoration: const pw.BoxDecoration(
              border: pw.Border(right: pw.BorderSide(width: 1)),
            ),
          );
        }

        pw.Widget cellMode3(
            String text, double fontSize, double width, double height) {
          return pw.Container(
            alignment: pw.Alignment.bottomCenter,
            height: height,
            width: width,
            padding: const pw.EdgeInsets.only(right: 1),
            child: pw.Text(text,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: fontSize)),
            decoration: const pw.BoxDecoration(
              border: pw.Border(right: pw.BorderSide(width: 1)),
            ),
          );
        }

        rows.add(pw.TableRow(
            verticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: [
              cellMode1(forPayment.itinerarieCode),
              cellMode1(forPayment.itinerariesShift),
              cellMode1(forPayment.schoolsName.join(', ')),
              cellMode1(forPayment.trajectory),
              pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        cellMode2(
                            forPayment.levels['INFANTIL'].toString().isEmpty ||
                                    forPayment.levels['INFANTIL'] == null
                                ? '0'
                                : forPayment.levels['INFANTIL'].toString()),
                        cellMode2(forPayment.levels['FUNDAMENTAL']
                                    .toString()
                                    .isEmpty ||
                                forPayment.levels['FUNDAMENTAL'] == null
                            ? '0'
                            : forPayment.levels['FUNDAMENTAL'].toString()),
                        cellMode2(
                            forPayment.levels['MÉDIO'].toString().isEmpty ||
                                    forPayment.levels['MÉDIO'] == null
                                ? '0'
                                : forPayment.levels['MÉDIO'].toString()),
                        cellMode2(
                            forPayment.levels['INTEGRAL'].toString().isEmpty ||
                                    forPayment.levels['INTEGRAL'] == null
                                ? '0'
                                : forPayment.levels['INTEGRAL'].toString()),
                        cellMode2(
                            forPayment.levels['ESPECIAL'].toString().isEmpty ||
                                    forPayment.levels['ESPECIAL'] == null
                                ? '0'
                                : forPayment.levels['ESPECIAL'].toString()),
                        cellMode2(forPayment.levels['EJA'].toString().isEmpty ||
                                forPayment.levels['EJA'] == null
                            ? '0'
                            : forPayment.levels['EJA'].toString()),
                        pw.Container(
                          height: 30,
                          alignment: pw.Alignment.bottomCenter,
                          child: pw.Text(totalStudents.toString(),
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 5)),
                        ),
                      ])),
              pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        pw.Container(
                          alignment: pw.Alignment.bottomCenter,
                          height: 30,
                          padding:
                              const pw.EdgeInsets.only(right: 1, bottom: 2),
                          child: pw.Transform(
                            adjustLayout: true,
                            transform: Matrix4.rotationZ(90 * 3.1415927 / 180),
                            child: pw.Text(
                                forPayment.vehiclePlate.split(', ').join('\n'),
                                textAlign: pw.TextAlign.center,
                                style: const pw.TextStyle(fontSize: 4)),
                          ),
                        ),
                      ])),
              pw.Container(
                  alignment: pw.Alignment.bottomCenter,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        cellMode3(kmRegular.toString(), 6, 22, 30),
                        cellMode3(quatityBusRegular.toString(), 6, 8, 30),
                        cellMode3(kmXBusRegular.toString(), 6, 22, 30),
                        cellMode3(
                            forPayment.callDaysCount.toString(), 6, 22, 30),
                        cellMode3(
                            kmXDayXBusRegular.toStringAsFixed(1), 6, 30, 30),
                      ])),
              pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Container(
                          alignment: pw.Alignment.bottomCenter,
                          height: 30,
                          width: 50,
                          child: pw.Text(
                              forPayment.driverName.split(', ').join('\n'),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 5)),
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(right: pw.BorderSide(width: 1)),
                          ),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.bottomCenter,
                          height: 30,
                          width: 40,
                          child: pw.Text(forPayment.monitorsName.join('\n'),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 4)),
                        ),
                      ])),
              pw.Container(
                  alignment: pw.Alignment.bottomCenter,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        cellMode3(kmEc.toString(), 6, 22, 30),
                        cellMode3(quatityBusEc.toString(), 6, 8, 30),
                        cellMode3(kmXBusEc.toString(), 6, 22, 30),
                        cellMode3(forPayment.callDaysRepositionCount.toString(),
                            6, 22, 30),
                        pw.Container(
                          alignment: pw.Alignment.bottomCenter,
                          height: 30,
                          width: 30,
                          padding: const pw.EdgeInsets.only(right: 1),
                          child: pw.Text(kmXDaysXBusEc.toStringAsFixed(1),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 6)),
                        ),
                      ])),
            ]));
      }
      valorTotalRegular = somaKmRegulares * contractValue;
      valorTotalAtividadesDiferenciadas =
          somaKmAtividadesDiferenciadas * contractValue;
      valorTotalGeral = valorTotalRegular + valorTotalAtividadesDiferenciadas;
      somaKmTotal = somaKmRegulares + somaKmAtividadesDiferenciadas;
      somaBusTotal = somaBusMatutino +
          somaBusVespertino +
          somaBusNoturno +
          somaBusIntegral;

      return pw.Table(
          border: pw.TableBorder.all(width: 1),
          columnWidths: const <int, pw.TableColumnWidth>{
            0: pw.FlexColumnWidth(0.5),
            1: pw.FlexColumnWidth(0.5),
            2: pw.FlexColumnWidth(0.6),
            3: pw.FlexColumnWidth(1),
            4: pw.FlexColumnWidth(0.8),
            5: pw.FlexColumnWidth(0.4),
            6: pw.FlexColumnWidth(1.1),
            7: pw.FlexColumnWidth(0.95),
            8: pw.FlexColumnWidth(1.1),
          },
          children: rows);
    }

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(8),
        orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            buildHeader(context, monthName),
            pw.SizedBox(height: 20),
            forPaymentTable(context, forPayments),
          ];
        },
      ),
    );

    pw.Widget cellTotalizador(pw.Context context, String text1, String text2) {
      return pw.Container(
        height: 40,
        alignment: pw.Alignment.bottomCenter,
        padding: const pw.EdgeInsets.symmetric(horizontal: 1),
        child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(text1,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 8)),
              pw.Text(text2,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10)),
            ]),
      );
    }

    int infMat = somaPorNivelETurno['INFANTIL_MATUTINO'] ?? 0;
    int infVes = somaPorNivelETurno['INFANTIL_VESPERTINO'] ?? 0;
    int infNot = somaPorNivelETurno['INFANTIL_NOTURNO'] ?? 0;
    int infInt = somaPorNivelETurno['INFANTIL_INTEGRAL'] ?? 0;
    int somaInf = infMat + infVes + infNot + infInt;
    double percentInf = (somaInf / somaTotalLinha) * 100;
    valorInfantil = valorTotalGeral * percentInf / 100;

    int fundMat = somaPorNivelETurno['FUNDAMENTAL_MATUTINO'] ?? 0;
    int fundVes = somaPorNivelETurno['FUNDAMENTAL_VESPERTINO'] ?? 0;
    int fundNot = somaPorNivelETurno['FUNDAMENTAL_NOTURNO'] ?? 0;
    int fundInt = somaPorNivelETurno['FUNDAMENTAL_INTEGRAL'] ?? 0;
    int somaFund = fundMat + fundVes + fundNot + fundInt;
    double percentFund = (somaFund / somaTotalLinha) * 100;
    valorFundamental = valorTotalGeral * percentFund / 100;

    int medMat = somaPorNivelETurno['MÉDIO_MATUTINO'] ?? 0;
    int medVes = somaPorNivelETurno['MÉDIO_VESPERTINO'] ?? 0;
    int medNot = somaPorNivelETurno['MÉDIO_NOTURNO'] ?? 0;
    int medInt = somaPorNivelETurno['MÉDIO_INTEGRAL'] ?? 0;
    int somaMed = medMat + medVes + medNot + medInt;
    double percentMed = (somaMed / somaTotalLinha) * 100;
    valorMedio = valorTotalGeral * percentMed / 100;

    int intMat = somaPorNivelETurno['INTEGRAL_MATUTINO'] ?? 0;
    int intVes = somaPorNivelETurno['INTEGRAL_VESPERTINO'] ?? 0;
    int intNot = somaPorNivelETurno['INTEGRAL_NOTURNO'] ?? 0;
    int intInt = somaPorNivelETurno['INTEGRAL_INTEGRAL'] ?? 0;
    int somaInt = intMat + intVes + intNot + intInt;
    double percentInt = (somaInt / somaTotalLinha) * 100;
    valorIntegral = valorTotalGeral * percentInt / 100;

    int espMat = somaPorNivelETurno['ESPECIAL_MATUTINO'] ?? 0;
    int espVes = somaPorNivelETurno['ESPECIAL_VESPERTINO'] ?? 0;
    int espNot = somaPorNivelETurno['ESPECIAL_NOTURNO'] ?? 0;
    int espInt = somaPorNivelETurno['ESPECIAL_INTEGRAL'] ?? 0;
    int somaEsp = espMat + espVes + espNot + espInt;
    double percentEsp = (somaEsp / somaTotalLinha) * 100;
    valorEspecial = valorTotalGeral * percentEsp / 100;

    int ejaMat = somaPorNivelETurno['EJA_MATUTINO'] ?? 0;
    int ejaVes = somaPorNivelETurno['EJA_VESPERTINO'] ?? 0;
    int ejaNot = somaPorNivelETurno['EJA_NOTURNO'] ?? 0;
    int ejaInt = somaPorNivelETurno['EJA_INTEGRAL'] ?? 0;
    int somaEja = ejaMat + ejaVes + ejaNot + ejaInt;
    double percentEja = (somaEja / somaTotalLinha) * 100;
    valorEja = valorTotalGeral * percentEja / 100;

    int matTotal = infMat + fundMat + medMat + intMat + espMat + ejaMat;
    int vesTotal = infVes + fundVes + medVes + intVes + espVes + ejaVes;
    int notTotal = infNot + fundNot + medNot + intNot + espNot + ejaNot;
    int integralTotal = infInt + fundInt + medInt + intInt + espInt + ejaInt;
    int totalTotal = somaInf + somaFund + somaMed + somaInt + somaEsp + somaEja;
    double percentTotal = (totalTotal / somaTotalLinha) * 100;
    pw.Widget headerTotalizador(pw.Context context) {
      List<pw.TableRow> rows = [];

      rows.add(pw.TableRow(children: [
        cellTotalizador(context, 'VALOR DA NOTA FISCAL\nEM R\$',
            formatador.format(valorTotalGeral)),
        cellTotalizador(context, 'ENSINO INFANTIL EM R\$',
            formatador.format(valorInfantil)),
        cellTotalizador(context, 'ENSINO FUNDAMENTAL EM R\$',
            formatador.format(valorFundamental)),
        cellTotalizador(
            context, 'ENSINO MÉDIO EM R\$', formatador.format(valorMedio)),
        cellTotalizador(context, 'ENSINO INTEGRAL EM R\$',
            formatador.format(valorIntegral)),
        cellTotalizador(context, 'ENSINO ESPECIAL EM R\$',
            formatador.format(valorEspecial)),
        cellTotalizador(context, 'EJA EM R\$', formatador.format(valorEja)),
        cellTotalizador(
            context, 'CONTRATO: $contract', 'VALOR KM: R\$ $contractValue'),
      ]));
      return pw.Table(
          border: pw.TableBorder.all(width: 1),
          columnWidths: const <int, pw.TableColumnWidth>{
            0: pw.FlexColumnWidth(1),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
            3: pw.FlexColumnWidth(1),
            4: pw.FlexColumnWidth(1),
            5: pw.FlexColumnWidth(1),
            6: pw.FlexColumnWidth(1),
            7: pw.FlexColumnWidth(1),
          },
          children: rows);
    }

    pw.Widget cellModalidadeEnsino(String text) {
      return pw.Container(
        height: 20,
        alignment: pw.Alignment.bottomCenter,
        padding: const pw.EdgeInsets.symmetric(horizontal: 1),
        child: pw.Text(text,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
      );
    }

    pw.Widget modalEnsinoTable() {
      return pw.Container(
          width: 140,
          alignment: pw.Alignment.centerLeft,
          child: pw.Table(border: pw.TableBorder.all(width: 1), children: [
            pw.TableRow(
              children: [
                pw.Text('MODALIDADE DE ENSINO',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.TableRow(
              children: [
                cellModalidadeEnsino('ENSINO INFANTIL'),
              ],
            ),
            pw.TableRow(
              children: [
                cellModalidadeEnsino('ENSINO FUNDAMENTAL'),
              ],
            ),
            pw.TableRow(
              children: [
                cellModalidadeEnsino('ENSINO MÉDIO'),
              ],
            ),
            pw.TableRow(
              children: [
                cellModalidadeEnsino('ENSINO INTEGRAL'),
              ],
            ),
            pw.TableRow(
              children: [
                cellModalidadeEnsino('ENSINO ESPECIAL'),
              ],
            ),
            pw.TableRow(
              children: [
                cellModalidadeEnsino('EJA'),
              ],
            ),
            pw.TableRow(
              children: [
                cellModalidadeEnsino('TOTAL'),
              ],
            ),
          ]));
    }

    pw.Widget cellOfquatityStudentsForShiftTable(String text) {
      return pw.Container(
        height: 20,
        width: 20,
        alignment: pw.Alignment.bottomCenter,
        padding: const pw.EdgeInsets.symmetric(horizontal: 1),
        child: pw.Text(text,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
      );
    }

    pw.Widget cellOfquatityStudentsForShiftTabletwo(String text) {
      return pw.Container(
        height: 20,
        width: 180,
        alignment: pw.Alignment.bottomCenter,
        padding: const pw.EdgeInsets.symmetric(horizontal: 1),
        child: pw.Text(text,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6)),
      );
    }

    pw.Widget cellShiftTable(String text, double widt) {
      return pw.Container(
        padding: const pw.EdgeInsets.only(top: 5),
        width: widt,
        height: 12,
        child: pw.Text(text,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 5)),
        decoration: const pw.BoxDecoration(
            border: pw.Border(right: pw.BorderSide(width: 1))),
      );
    }

    pw.Widget quatityStudentsForShiftTable() {
      return pw.Container(
        width: 240,
        child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Container(
                  child: pw.Column(children: [
                pw.Container(
                  height: 12,
                  alignment: pw.Alignment.topCenter,
                  padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                  child: pw.Text('QUANTIDADE DE ALUNOS POR TURNO',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 5)),
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(width: 1))),
                ),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      cellShiftTable('MAT', 29),
                      cellShiftTable('VES', 29),
                      cellShiftTable('NOT', 29),
                      cellShiftTable('INT', 30),
                      cellShiftTable('TOTAL', 30),
                      pw.Container(
                        padding: const pw.EdgeInsets.only(left: 10, top: 5),
                        width: 8,
                        height: 12,
                        child: pw.Text('%',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 5)),
                      ),
                    ])
              ])),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  pw.TableRow(children: [
                    cellOfquatityStudentsForShiftTabletwo(infMat.toString()),
                    cellOfquatityStudentsForShiftTabletwo(infVes.toString()),
                    cellModalidadeEnsino(infNot.toString()),
                    cellOfquatityStudentsForShiftTabletwo(infInt.toString()),
                    cellOfquatityStudentsForShiftTabletwo(somaInf.toString()),
                    cellOfquatityStudentsForShiftTabletwo(
                        '${percentInf.toStringAsFixed(2)}%'),
                  ]),
                  pw.TableRow(children: [
                    cellOfquatityStudentsForShiftTabletwo(fundMat.toString()),
                    cellOfquatityStudentsForShiftTabletwo(fundVes.toString()),
                    cellOfquatityStudentsForShiftTabletwo(fundNot.toString()),
                    cellOfquatityStudentsForShiftTabletwo(fundInt.toString()),
                    cellOfquatityStudentsForShiftTabletwo(somaFund.toString()),
                    cellOfquatityStudentsForShiftTabletwo(
                        '${percentFund.toStringAsFixed(2)}%'),
                  ]),
                  pw.TableRow(children: [
                    cellOfquatityStudentsForShiftTabletwo(medMat.toString()),
                    cellOfquatityStudentsForShiftTabletwo(medVes.toString()),
                    cellOfquatityStudentsForShiftTabletwo(medNot.toString()),
                    cellOfquatityStudentsForShiftTabletwo(medInt.toString()),
                    cellOfquatityStudentsForShiftTabletwo(somaMed.toString()),
                    cellOfquatityStudentsForShiftTabletwo(
                        '${percentMed.toStringAsFixed(2)}%'),
                  ]),
                  pw.TableRow(children: [
                    cellOfquatityStudentsForShiftTabletwo(intMat.toString()),
                    cellOfquatityStudentsForShiftTabletwo(intVes.toString()),
                    cellOfquatityStudentsForShiftTabletwo(intNot.toString()),
                    cellOfquatityStudentsForShiftTabletwo(intInt.toString()),
                    cellOfquatityStudentsForShiftTabletwo(somaInt.toString()),
                    cellOfquatityStudentsForShiftTabletwo(
                        '${percentInt.toStringAsFixed(2)}%'),
                  ]),
                  pw.TableRow(children: [
                    cellOfquatityStudentsForShiftTabletwo(espMat.toString()),
                    cellOfquatityStudentsForShiftTabletwo(espVes.toString()),
                    cellOfquatityStudentsForShiftTabletwo(espNot.toString()),
                    cellOfquatityStudentsForShiftTabletwo(espInt.toString()),
                    cellOfquatityStudentsForShiftTabletwo(somaEsp.toString()),
                    cellOfquatityStudentsForShiftTabletwo(
                        '${percentEsp.toStringAsFixed(2)}%'),
                  ]),
                  pw.TableRow(children: [
                    cellOfquatityStudentsForShiftTabletwo(ejaMat.toString()),
                    cellOfquatityStudentsForShiftTabletwo(ejaVes.toString()),
                    cellOfquatityStudentsForShiftTabletwo(ejaNot.toString()),
                    cellOfquatityStudentsForShiftTabletwo(ejaInt.toString()),
                    cellOfquatityStudentsForShiftTabletwo(somaEja.toString()),
                    cellOfquatityStudentsForShiftTabletwo(
                        '${percentEja.toStringAsFixed(2)}%'),
                  ]),
                  pw.TableRow(children: [
                    cellOfquatityStudentsForShiftTabletwo(matTotal.toString()),
                    cellOfquatityStudentsForShiftTabletwo(vesTotal.toString()),
                    cellOfquatityStudentsForShiftTabletwo(notTotal.toString()),
                    cellOfquatityStudentsForShiftTabletwo(
                        integralTotal.toString()),
                    cellOfquatityStudentsForShiftTabletwo(
                        totalTotal.toString()),
                    cellOfquatityStudentsForShiftTabletwo(
                        '${percentTotal.toStringAsFixed(2)}%'),
                  ]),
                ],
              ),
            ]),
      );
    }

    pw.Widget cellOfItineraryForShiftTable(String text) {
      return pw.Container(
        height: 20,
        alignment: pw.Alignment.bottomCenter,
        padding: const pw.EdgeInsets.symmetric(horizontal: 1),
        child: pw.Text(
          text,
          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
        ),
      );
    }

    pw.Widget itineraryForShiftTable() {
      return pw.Container(
        width: 240,
        child: pw.Column(children: [
          pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Text('ITINERÁRIOS POR TURNO',
                textAlign: pw.TextAlign.center,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
          ),
          pw.Table(
            border: pw.TableBorder.all(width: 1),
            children: [
              pw.TableRow(children: [
                cellOfItineraryForShiftTable('MATUTINO'),
                cellOfItineraryForShiftTable(somaItiMatutino.toString()),
              ]),
              pw.TableRow(children: [
                cellOfItineraryForShiftTable('VESPERTINO'),
                cellOfItineraryForShiftTable(somaItiVespertino.toString()),
              ]),
              pw.TableRow(children: [
                cellOfItineraryForShiftTable('NOTURNO'),
                cellOfItineraryForShiftTable(
                  somaItiNoturno.toString(),
                )
              ]),
              pw.TableRow(children: [
                cellOfItineraryForShiftTable('PROEITI'),
                cellOfItineraryForShiftTable('0'),
              ]),
              pw.TableRow(children: [
                cellOfItineraryForShiftTable('INTEGRAL'),
                cellOfItineraryForShiftTable(
                  somaItiIntegral.toString(),
                )
              ]),
              pw.TableRow(children: [
                cellOfItineraryForShiftTable('ESCOLA PARQUE'),
                cellOfItineraryForShiftTable('0'),
              ]),
              pw.TableRow(children: [
                cellOfItineraryForShiftTable('FORÇA NO ESPORTE'),
                cellOfItineraryForShiftTable('0'),
              ]),
              pw.TableRow(children: [
                cellOfItineraryForShiftTable('TOTAL'),
                cellOfItineraryForShiftTable(
                  totalItineraries.toString(),
                ),
              ]),
            ],
          ),
        ]),
      );
    }

    pw.Widget cellVehiclesForShiftTable(String text) {
      return pw.Container(
        height: 20,
        alignment: pw.Alignment.bottomCenter,
        padding: const pw.EdgeInsets.symmetric(horizontal: 1),
        child: pw.Text(text,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
      );
    }

    pw.Widget vehiclesForShiftTable() {
      return pw.Container(
        width: 240,
        child: pw.Column(children: [
          pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Text('VEÍCULOS POR TURNO',
                textAlign: pw.TextAlign.center,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
          ),
          pw.Table(
            border: pw.TableBorder.all(width: 1),
            children: [
              pw.TableRow(children: [
                cellVehiclesForShiftTable('MATUTINO'),
                cellVehiclesForShiftTable(
                  somaBusMatutino.toString(),
                )
              ]),
              pw.TableRow(children: [
                cellVehiclesForShiftTable('VESPERTINO'),
                cellVehiclesForShiftTable(
                  somaBusVespertino.toString(),
                )
              ]),
              pw.TableRow(children: [
                cellVehiclesForShiftTable('NOTURNO'),
                cellVehiclesForShiftTable(
                  somaBusNoturno.toString(),
                )
              ]),
              pw.TableRow(children: [
                cellVehiclesForShiftTable('PROEITI'),
                cellVehiclesForShiftTable('0'),
              ]),
              pw.TableRow(children: [
                cellVehiclesForShiftTable('INTEGRAL'),
                cellOfquatityStudentsForShiftTable(
                  somaBusIntegral.toString(),
                )
              ]),
              pw.TableRow(children: [
                cellVehiclesForShiftTable('ESCOLA PARQUE'),
                cellOfquatityStudentsForShiftTable('0'),
              ]),
              pw.TableRow(children: [
                cellVehiclesForShiftTable('FORÇA NO ESPORTE'),
                cellVehiclesForShiftTable('0'),
              ]),
              pw.TableRow(children: [
                cellVehiclesForShiftTable('TOTAL'),
                cellVehiclesForShiftTable(
                  somaBusTotal.toString(),
                )
              ]),
            ],
          ),
        ]),
      );
    }

    pw.Widget cellDifActvityTable(String text) {
      return pw.Container(
        height: 30,
        alignment: pw.Alignment.bottomCenter,
        padding: const pw.EdgeInsets.symmetric(horizontal: 1),
        child: pw.Text(text,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
      );
    }

    pw.Widget difActvutyTable() {
      return pw.Container(
        child: pw.Table(
          border: pw.TableBorder.all(width: 1),
          children: [
            pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                children: [
                  pw.Container(
                    height: 30,
                    alignment: pw.Alignment.bottomCenter,
                    padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                    child: pw.Text('QUILOMETRAGEM DAS ATIVIDADES DIFERENCIADAS',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 6)),
                  )
                ]),
            pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                children: [
                  cellDifActvityTable(
                      somaKmAtividadesDiferenciadas.toStringAsFixed(2)),
                ]),
            pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blue200),
                children: [
                  pw.Container(
                    height: 30,
                    alignment: pw.Alignment.bottomCenter,
                    padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                    child: pw.Text('QUILOMETRAGEM DAS ATIVIDADES REGULARES',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 6)),
                  )
                ]),
            pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blue200),
                children: [
                  cellDifActvityTable(somaKmRegulares.toStringAsFixed(2)),
                ]),
          ],
        ),
      );
    }

    pw.Widget totalKmTable() {
      return pw.Container(
        child: pw.Table(
          children: [
            pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                children: [
                  pw.Container(
                    height: 90,
                    alignment: pw.Alignment.bottomCenter,
                    padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                    child: pw.Text('QUILOMETRAGEM TOTAL',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 8)),
                    decoration: const pw.BoxDecoration(
                        border: pw.Border(bottom: pw.BorderSide(width: 1))),
                  ),
                ]),
            pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                children: [
                  pw.Container(
                    height: 80,
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                    child: pw.Text(somaKmTotal.toString(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  ),
                ]),
          ],
        ),
      );
    }

    pw.Widget urbanTable() {
      return pw.Container(
        width: 200,
        child: pw.Column(children: [
          pw.Table(
            border: pw.TableBorder.all(width: 1),
            children: [
              pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                  children: [
                    pw.Container(
                      alignment: pw.Alignment.bottomCenter,
                      padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                      child: pw.Text('URBANA',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8)),
                      decoration: const pw.BoxDecoration(
                          border: pw.Border(bottom: pw.BorderSide(width: 1))),
                    ),
                  ]),
              pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                  children: [
                    pw.Container(
                      alignment: pw.Alignment.center,
                      padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                      child: pw.Text('QUANTIDADE DE ESCOLA ATENDIDA',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8)),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.center,
                      padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                      child: pw.Text('TOTAL DE ALUNOS ATENDIDOS',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8)),
                    ),
                  ]),
              pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                  children: [
                    pw.Container(
                      alignment: pw.Alignment.center,
                      padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                      child: pw.Text(totalSchoolsUrban.toString(),
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.center,
                      padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                      child: pw.Text(totalStudentsUrban.toString(),
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                  ]),
            ],
          ),
        ]),
      );
    }

    pw.Widget ruralTable() {
      return pw.Container(
        width: 200,
        child: pw.Column(children: [
          pw.Table(
            border: pw.TableBorder.all(width: 1),
            children: [
              pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                  children: [
                    pw.Container(
                      alignment: pw.Alignment.bottomCenter,
                      padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                      child: pw.Text('RURAL',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8)),
                      decoration: const pw.BoxDecoration(
                          border: pw.Border(bottom: pw.BorderSide(width: 1))),
                    ),
                  ]),
              pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                  children: [
                    pw.Container(
                      alignment: pw.Alignment.center,
                      padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                      child: pw.Text('QUANTIDADE DE ESCOLA ATENDIDA',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8)),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.center,
                      padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                      child: pw.Text('TOTAL DE ALUNOS ATENDIDOS',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 8)),
                    ),
                  ]),
              pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                  children: [
                    pw.Container(
                      alignment: pw.Alignment.center,
                      padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                      child: pw.Text(totalSchoolsRural.toString(),
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.center,
                      padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                      child: pw.Text(totalStudentsRural.toString(),
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                  ]),
            ],
          ),
        ]),
      );
    }

    pw.Widget signTable() {
      return pw.Container(
        height: 120,
        child: pw.Table(
          border:
              pw.TableBorder.symmetric(outside: const pw.BorderSide(width: 1)),
          children: [
            pw.TableRow(children: [
              pw.Container(
                height: 20,
                alignment: pw.Alignment.bottomLeft,
                padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                child: pw.Text('Data: ____/____/____',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 8)),
                decoration: const pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(width: 1))),
              ),
            ]),
            pw.TableRow(children: [
              pw.Container(
                height: 40,
                alignment: pw.Alignment.bottomLeft,
                padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                child: pw.Text('EXECUTOR DO CONTRATO: ',
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 8)),
              ),
              pw.Container(
                height: 40,
                alignment: pw.Alignment.bottomLeft,
                padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                child: pw.Text('MATRÍCULA: ',
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 8)),
              ),
              pw.Container(
                width: 150,
                height: 40,
                alignment: pw.Alignment.bottomLeft,
                padding: const pw.EdgeInsets.symmetric(horizontal: 1),
                child: pw.Text('CHEFE UNIAE: ',
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 8)),
              ),
            ]),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Table(border: pw.TableBorder.all(width: 1), children: [
              pw.TableRow(children: [
                pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                      'QUADRO DEMONSTRATIVO TOTALIZADOR - REGIÃO: ITAPOÃ',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 14)),
                )
              ]),
            ]),
            pw.Table(border: pw.TableBorder.all(width: 1), children: [
              pw.TableRow(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 20,
                        child: pw.Text('MÊS: $monthName',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 12)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        width: 150,
                        height: 20,
                        child: pw.Text('ANO:          ${Constants.kYEAR}',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 12)),
                        decoration: const pw.BoxDecoration(
                            border: pw.Border.symmetric(
                                vertical: pw.BorderSide(width: 1))),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.bottomCenter,
                        height: 20,
                        child: pw.Text('Nº PROCESSO SEI: ${Constants.kSEI}',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 12)),
                      ),
                    ]),
              ]),
            ]),
            headerTotalizador(context),
            pw.Container(
              height: 20,
              alignment: pw.Alignment.bottomLeft,
              child: pw.Text('OBSERVAÇÕES:',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10)),
            ),
            pw.Table(border: pw.TableBorder.all(width: 1), children: [
              pw.TableRow(children: [
                pw.Container(height: 80, child: pw.Text('.')),
              ]),
            ]),
            pw.SizedBox(height: 20),
            pw.Table(border: pw.TableBorder.all(width: 1), children: [
              pw.TableRow(children: [
                modalEnsinoTable(),
                quatityStudentsForShiftTable(),
                itineraryForShiftTable(),
                vehiclesForShiftTable(),
                difActvutyTable(),
                totalKmTable(),
              ]),
            ]),
            pw.SizedBox(height: 20),
            pw.Row(children: [
              urbanTable(),
              pw.SizedBox(width: 20),
              ruralTable(),
            ]),
            pw.SizedBox(height: 20),
            signTable(),
          ];
        },
      ),
    );
    final Uint8List pdfBytes = await pdf.save();

    if (kIsWeb) {
      // Código para web usando universal_html
      final blob = html.Blob([pdfBytes], 'quadro_itinerarios/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // ignore: unused_local_variable
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'quadro_itinerarios.pdf')
        ..click();

      html.Url.revokeObjectUrl(url);
    } else {
      // Código para outras plataformas (Android, iOS, etc.)
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/quadro_itinerarios.pdf');
      await file.writeAsBytes(pdfBytes);

      // Você pode agora abrir o arquivo para impressão ou compartilhamento, etc.
    }
    return await pdf.save();
  }
}
