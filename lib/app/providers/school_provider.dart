import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/school.dart';

class SchoolProvider extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore;
  SchoolProvider({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  School? _school;

  School? get school => _school;

  set school(School? value) {
    _school = value;
    notifyListeners();
  }

  List<School> _schools = [];

  List<School> get schools => _schools;

  set schools(List<School> value) {
    _schools = value;
    notifyListeners();
  }

  Future<void> createSchool({required School school}) async {
    try {
      final doc =
          await _firebaseFirestore.collection('schools').add(school.toJson());
      school.id = doc.id;
      await _firebaseFirestore
          .collection('schools')
          .doc(doc.id)
          .set(school.toJson());

      notifyListeners();
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<School> getSchool(String id) async {
    try {
      final snapshot =
          await _firebaseFirestore.collection('schools').doc(id).get();
      _school = School.fromJson(snapshot.data()!);
      _isLoading = true;
      notifyListeners();
      return _school!;
    } catch (e) {
      throw e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<School>> getSchools() async {
    try {
      final snapshot = await _firebaseFirestore.collection('schools').get();
      _schools = snapshot.docs.map((e) => School.fromJson(e.data())).toList();
      return _schools;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> getNameSchoolByStudent(String studentId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('schools')
          .where('studentsId', arrayContains: studentId)
          .get();
      final school = snapshot.docs.map((e) => School.fromJson(e.data())).first;
      return school.name;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateSchool(School school) async {
    try {
      await _firebaseFirestore
          .collection('schools')
          .doc(school.id)
          .update(school.toJson());
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteSchool(String id) async {
    try {
      await _firebaseFirestore.collection('schools').doc(id).delete();
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> addStudentToSchool(
      {required String schoolId, required String studentId}) async {
    try {
      await _firebaseFirestore.collection('schools').doc(schoolId).update({
        'studentsId': FieldValue.arrayUnion([studentId])
      });
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> removeStudentFromSchool(
      {required String schoolId, required String studentId}) async {
    try {
      await _firebaseFirestore.collection('schools').doc(schoolId).update({
        'studentsId': FieldValue.arrayRemove([studentId])
      });
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> getSchoolByAppUserId(String appUserId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('schools')
          .where('appUserId', arrayContains: appUserId)
          .get();
      if (snapshot.docs.isEmpty) {
        return;
      }
      final school = snapshot.docs.map((e) => School.fromJson(e.data())).first;
      _school = school;
      notifyListeners();
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<void> addAppUserToSchool(
      {required String schoolId, required String appUserId}) async {
    try {
      await _firebaseFirestore.collection('schools').doc(schoolId).update({
        'appUserId': FieldValue.arrayUnion([appUserId])
      });
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> removeAppUserToSchool(
      {required String schoolId, required String appUserId}) async {
    try {
      await _firebaseFirestore.collection('schools').doc(schoolId).update({
        'appUserId': FieldValue.arrayRemove([appUserId])
      });
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<int> getNumberTotalSchools() async {
    try {
      final snapshot = await _firebaseFirestore.collection('schools').get();
      final numberofSchools = snapshot.docs.length;
      notifyListeners();
      return numberofSchools;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberSchoolRuralLocation() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('schools')
          .where('type', isEqualTo: 'RURAL')
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }

  Future<int> getNumberSchoolUrbanLocation() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('schools')
          .where('type', isEqualTo: 'URBANA')
          .get();
      final numberofStudents = snapshot.docs.length;
      notifyListeners();
      return numberofStudents;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Ocorreu um erro desconhecido';
    }
  }
}
