import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/e_c_student.dart';

class ECStudentProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore;
  ECStudentProvider({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;
  ECStudent? _ecStudent;
  ECStudent? get ecStudent => _ecStudent;
  set ecStudent(ECStudent? value) {
    _ecStudent = value;
    notifyListeners();
  }

  List<ECStudent> _ecStudents = [];
  List<ECStudent> get ecStudents => _ecStudents;
  set ecStudents(List<ECStudent> value) {
    _ecStudents = value;
    notifyListeners();
  }

  Future<void> createECStudent({required ECStudent ecStudent}) async {
    try {
      final doc = await _firebaseFirestore
          .collection('ecStudents')
          .add(ecStudent.toJson());
      ecStudent.id = doc.id;
      await _firebaseFirestore
          .collection('ecStudents')
          .doc(doc.id)
          .set(ecStudent.toJson());
      notifyListeners();
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<ECStudent> getECStudent(String id) async {
    try {
      final snapshot =
          await _firebaseFirestore.collection('ecStudents').doc(id).get();
      _ecStudent = ECStudent.fromJson(snapshot.data()!);
      notifyListeners();
      return _ecStudent!;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<ECStudent>> getECStudents() async {
    try {
      final snapshot = await _firebaseFirestore.collection('ecStudents').get();
      _ecStudents =
          snapshot.docs.map((e) => ECStudent.fromJson(e.data())).toList();
      return _ecStudents;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<ECStudent>> getECStudentsBySchool(String schoolId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('ecStudents')
          .where('school_id', isEqualTo: schoolId)
          .get();
      _ecStudents =
          snapshot.docs.map((e) => ECStudent.fromJson(e.data())).toList();
      return _ecStudents;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteECStudent(String id) async {
    try {
      await _firebaseFirestore.collection('ecStudents').doc(id).delete();
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }
}
