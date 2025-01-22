import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/for_payment.dart';
import '../models/itinerary.dart';
import '../models/school.dart';
import '../models/student.dart';

class ForPaymentProvider extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore;

  // Propriedades principais
  ForPayment? _forPayment;
  List<ForPayment> _forPayments = [];
  List<Student> _students = []; // Lista de todos os estudantes
  ForPaymentProvider({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  // Getters e setters
  ForPayment? get forPayment => _forPayment;
  set forPayment(ForPayment? value) {
    _forPayment = value;
    notifyListeners();
  }

  List<ForPayment> get forPayments => _forPayments;
  set forPayments(List<ForPayment> value) {
    _forPayments = value;
    notifyListeners();
  }

  // Método para gerar os pagamentos do mês
  Future<void> generateForPaymentMonth({
    required DateTime monthYear,
    required String contract,
    required double valor,
  }) async {
    try {
      print('Gerando pagamentos para o mês de ${monthYear.month}');

      // 1. Carregar todos os estudantes de uma vez
      final studentsSnapshot =
          await _firebaseFirestore.collection('students').get();
      _students = studentsSnapshot.docs
          .map((doc) => Student.fromJson(doc.data()))
          .toList();
      print('Total de estudantes carregados: ${_students.length}');

      // 2. Carregar itinerários relacionados ao contrato
      final itinerariesSnapshot = await _firebaseFirestore
          .collection('itineraries')
          .where('contract', isEqualTo: contract)
          .get();

      List<Itinerary> itineraries = itinerariesSnapshot.docs
          .map((doc) => Itinerary.fromJson(doc.data()))
          .toList();

      print('Total de itinerários carregados: ${itineraries.length}');

      // 3. Processar cada itinerário separando os estudantes carregados
      for (var itinerary in itineraries) {
        List<Student> studentsInItinerary = _students.where((student) {
          return itinerary.studentsId?.contains(student.id) ?? false;
        }).toList();

        List<String> schoolsName = [];
        Map<String, int> levels = {};
        Map<String, int> residenceTypeCount = {};
        int totalStudentsRural = 0;
        int totalStudentsUrban = 0;

        // 4. Processamento dos estudantes no itinerário
        for (var student in studentsInItinerary) {
          // Contabilizar estudantes por tipo de residência
          if (student.residenceType == 'RURAL') {
            residenceTypeCount['RURAL'] =
                (residenceTypeCount['RURAL'] ?? 0) + 1;
          } else {
            residenceTypeCount['URBANA'] =
                (residenceTypeCount['URBANA'] ?? 0) + 1;
          }

          // Contabilizar estudantes por nível
          levels[student.level] = (levels[student.level] ?? 0) + 1;
        }

        totalStudentsRural = residenceTypeCount['RURAL'] ?? 0;
        totalStudentsUrban = residenceTypeCount['URBANA'] ?? 0;

        // 5. Processamento das escolas no itinerário
        final schoolFutures = itinerary.schoolIds?.map((schoolId) async {
          final schoolDoc = await _firebaseFirestore
              .collection('schools')
              .doc(schoolId)
              .get();
          if (schoolDoc.exists) {
            final schoolData = schoolDoc.data();
            if (schoolData != null) {
              return School.fromJson(schoolData);
            }
          }
          return null;
        }).toList();

        if (schoolFutures != null) {
          final schools = await Future.wait(schoolFutures);
          schools.whereType<School>().forEach((school) {
            schoolsName.add(school.name);
          });
        }

        // Processamento das monitoras
        List<String> monitoras = [];
        if (itinerary.appUserId.isNotEmpty) {
          final monitorDoc = await _firebaseFirestore
              .collection('users')
              .doc(itinerary.appUserId)
              .get();
          if (monitorDoc.exists) {
            final monitorData = monitorDoc.data();
            if (monitorData != null) {
              monitoras.add(monitorData['name'] ?? 'Nome não disponível');
            }
          } else {
            monitoras.add('Monitor não encontrado');
          }
        } else {
          monitoras.add('Sem monitor');
        }

        // 6. Criação do objeto ForPayment para o itinerário
        final forPayment = ForPayment(
          id: itinerary.id,
          itinerarieCode: itinerary.code,
          itinerariesShift: itinerary.shift,
          schoolsName: schoolsName,
          schoolsTypeRuralCount: totalStudentsRural,
          schoolsTypeUrbanCount: totalStudentsUrban,
          trajectory: itinerary.trajectory,
          levels: levels,
          vehiclePlate: itinerary.vehiclePlate,
          kilometer: itinerary.kilometer,
          driverName: itinerary.driverName,
          monitorsId: [itinerary.appUserId],
          contract: contract,
          callDaysCount: 0, // Presença não está sendo processada
          callDaysRepositionCount: 0, // Presença não está sendo processada
          studentsUrban: totalStudentsUrban,
          studentsRural: totalStudentsRural,
          quantityOfBus: 1,
          dateOfEvent: monthYear,
          valor: valor,
          monitorsName: monitoras,
        );

        // 7. Salvar o pagamento no Firestore
        await createForPayment(forPayment: forPayment);
      }

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Método auxiliar para criar o pagamento no Firestore
  Future<void> createForPayment({required ForPayment forPayment}) async {
    try {
      await _firebaseFirestore
          .collection('forPayment')
          .add(forPayment.toJson());
      notifyListeners();
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  // Método para obter a lista de pagamentos
  Future<List<ForPayment>> getForPayimentList({
    required String contract,
    required DateTime month,
  }) async {
    try {
      List<ForPayment> regular = [];
      List<ForPayment> ec = [];
      final snapshot = await _firebaseFirestore
          .collection('forPayment')
          .where('contract', isEqualTo: contract)
          .get();
      _forPayments =
          snapshot.docs.map((e) => ForPayment.fromJson(e.data())).toList();
      for (var forPayment in _forPayments) {
        if (forPayment.itinerarieCode == 'Atividade Extracurricular') {
          ec.add(forPayment);
        } else {
          regular.add(forPayment);
        }
      }
      _forPayments = regular + ec;

      notifyListeners();
      return _forPayments;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> clearForPayment() async {
    try {
      // Obter todos os documentos na coleção 'forPayment'
      final snapshot = await _firebaseFirestore.collection('forPayment').get();

      // Excluir cada documento
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Limpar a lista local e notificar os ouvintes
      _forPayments = [];
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }
}
