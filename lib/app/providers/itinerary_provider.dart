import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pollo2025/app/models/itinerary.dart';
import 'package:pollo2025/app/models/student.dart';

import '../core/exceptions/fetch_data_exceptions.dart';

class ItineraryProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore;
  ItineraryProvider({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;
  Itinerary? _itinerary;
  Itinerary? get itinerary => _itinerary;
  set itinerary(Itinerary? value) {
    _itinerary = value;
    notifyListeners();
  }

  List<Itinerary> _itineraries = [];
  List<Itinerary> get itineraries => _itineraries;
  set itineraries(List<Itinerary> value) {
    _itineraries = value;
    notifyListeners();
  }

  Future<void> createItinerary({required Itinerary itinerary}) async {
    try {
      final doc = await _firebaseFirestore
          .collection('itineraries')
          .add(itinerary.toJson());
      itinerary.id = doc.id;
      await _firebaseFirestore
          .collection('itineraries')
          .doc(doc.id)
          .set(itinerary.toJson());
      notifyListeners();
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<Itinerary> getItinerary(String id) async {
    try {
      final snapshot =
          await _firebaseFirestore.collection('itineraries').doc(id).get();
      _itinerary = Itinerary.fromJson(snapshot.data()!);
      notifyListeners();
      return _itinerary!;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Itinerary>> getItineraries() async {
    try {
      final snapshot = await _firebaseFirestore.collection('itineraries').get();
      _itineraries =
          snapshot.docs.map((e) => Itinerary.fromJson(e.data())).toList();
      return _itineraries;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateItineraryContract() async {
    for (var iti in itineraries) {
      await _firebaseFirestore
          .collection('itineraries')
          .doc(iti.id)
          .update({'contract': '12/2024'});
    }
  }

  Future<void> updateItinerary(Itinerary itinerary) async {
    try {
      await _firebaseFirestore
          .collection('itineraries')
          .doc(itinerary.id)
          .update(itinerary.toJson());
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteItinerary(Itinerary itinerary) async {
    await _firebaseFirestore
        .collection('itineraries')
        .doc(itinerary.id)
        .delete();
    notifyListeners();
  }

  Future<void> addStudentToItineraryByAdmin(
      {required String itineraryId, required Student student}) async {
    try {
      await _firebaseFirestore
          .collection('itineraries')
          .doc(itineraryId)
          .update({
        'studentsId': FieldValue.arrayUnion([student.id])
      });
      await _firebaseFirestore.collection('students').doc(student.id).update(
          {'itineraryId': itineraryId, 'authorized': true, 'imageFormUrl': ''});

      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> removeStudentFromItinerary(
      {required String itineraryId, required String studentId}) async {
    try {
      await _firebaseFirestore
          .collection('itineraries')
          .doc(itineraryId)
          .update({
        'studentsId': FieldValue.arrayRemove([studentId])
      });
      await _firebaseFirestore
          .collection('students')
          .doc(studentId)
          .update({'itineraryId': '', 'authorized': false});
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> addStudentToItineraryBySchoolMember(
      {required String itineraryId, required String studentId}) async {
    try {
      await _firebaseFirestore
          .collection('itineraries')
          .doc(itineraryId)
          .update({
        'studentsId': FieldValue.arrayUnion([studentId])
      });
      await _firebaseFirestore
          .collection('students')
          .doc(studentId)
          .update({'itineraryId': itineraryId});
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Itinerary>> getItinerariesBySchool(String schoolId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('itineraries')
          .where('schoolIds', arrayContains: schoolId)
          .get();
      _itineraries =
          snapshot.docs.map((e) => Itinerary.fromJson(e.data())).toList();
      return _itineraries;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> addSchoolToItinerary(
      {required String itineraryId, required String schoolId}) async {
    try {
      await _firebaseFirestore
          .collection('itineraries')
          .doc(itineraryId)
          .update({
        'schoolIds': FieldValue.arrayUnion([schoolId])
      });

      await _firebaseFirestore.collection('schools').doc(schoolId).update({
        'itinerariesId': FieldValue.arrayUnion([itineraryId])
      });
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> removeSchoolFromItinerary(
      {required String itineraryId, required String schoolId}) async {
    try {
      await _firebaseFirestore
          .collection('itineraries')
          .doc(itineraryId)
          .update({
        'schoolIds': FieldValue.arrayRemove([schoolId])
      });

      await _firebaseFirestore.collection('schools').doc(schoolId).update({
        'itinerariesId': FieldValue.arrayRemove([itineraryId])
      });
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> addMonitorToItinerary(
      {required String itineraryId, required String monitorId}) async {
    try {
      await _firebaseFirestore
          .collection('itineraries')
          .doc(itineraryId)
          .update({'appUserId': monitorId});
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> removeMonitorFromItinerary({required String itineraryId}) async {
    try {
      await _firebaseFirestore
          .collection('itineraries')
          .doc(itineraryId)
          .update({'appUserId': ''});
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Itinerary>> getItineraryByAppUserId(String appUserId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('itineraries')
          .where('appUserId', isEqualTo: appUserId)
          .get();
      _itineraries =
          snapshot.docs.map((e) => Itinerary.fromJson(e.data())).toList();
      notifyListeners();
      return _itineraries;
    } catch (e) {
      throw FetchDataException('Erro ao buscar itinerários: $e');
    }
  }

  Future<int> getNumberTotalItineraries() async {
    try {
      final snapshot = await _firebaseFirestore.collection('itineraries').get();
      final numberofItineraries = snapshot.docs.length;
      notifyListeners();
      return numberofItineraries;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberTotalItinerary() async {
    try {
      final snapshot = await _firebaseFirestore.collection('itineraries').get();
      final numberofItineraries = snapshot.docs.length;
      notifyListeners();
      return numberofItineraries;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberItineraryRuralLocation() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('itineraries')
          .where('type', isEqualTo: 'RURAL')
          .get();
      final numberofItineraries = snapshot.docs.length;
      notifyListeners();
      return numberofItineraries;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberItineraryUrbanLocation() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('itineraries')
          .where('type', isEqualTo: 'URBANO')
          .get();
      final numberofItineraries = snapshot.docs.length;
      notifyListeners();
      return numberofItineraries;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberItineraryMixLocation() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('itineraries')
          .where('type', isEqualTo: 'MISTO')
          .get();
      final numberofItineraries = snapshot.docs.length;
      notifyListeners();
      return numberofItineraries;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberItineraryIntegral() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('itineraries')
          .where('shift', isEqualTo: 'INTEGRAL')
          .get();
      final numberofItineraries = snapshot.docs.length;
      notifyListeners();
      return numberofItineraries;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberItineraryRegular() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('itineraries')
          .where('shift', isNotEqualTo: 'INTEGRAL')
          .get();
      final numberofItineraries = snapshot.docs.length;
      notifyListeners();
      return numberofItineraries;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }
}
