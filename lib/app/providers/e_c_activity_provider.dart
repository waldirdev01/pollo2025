import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pollo2025/app/models/extracurricular_activity.dart';

class ECActivityProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore;
  ECActivityProvider({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;
  ExtracurricularActivity? _ecActivity;
  ExtracurricularActivity? get ecActivity => _ecActivity;
  set ecActivity(ExtracurricularActivity? value) {
    _ecActivity = value;
    notifyListeners();
  }

  List<ExtracurricularActivity> _ecActivities = [];
  List<ExtracurricularActivity> get ecActivities => _ecActivities;
  set ecActivities(List<ExtracurricularActivity> value) {
    _ecActivities = value;
    notifyListeners();
  }

  Future<void> createECActivity(
      {required ExtracurricularActivity ecActivity}) async {
    try {
      final doc = await _firebaseFirestore
          .collection('ecActivities')
          .add(ecActivity.toJson());
      ecActivity.id = doc.id;
      await _firebaseFirestore
          .collection('ecActivities')
          .doc(doc.id)
          .set(ecActivity.toJson());
      notifyListeners();
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<ExtracurricularActivity> getECActivity(String id) async {
    try {
      final snapshot =
          await _firebaseFirestore.collection('ecActivities').doc(id).get();
      _ecActivity = ExtracurricularActivity.fromJson(snapshot.data()!);
      notifyListeners();
      return _ecActivity!;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<ExtracurricularActivity>> getECActivities() async {
    try {
      final snapshot =
          await _firebaseFirestore.collection('ecActivities').get();
      _ecActivities = snapshot.docs
          .map((e) => ExtracurricularActivity.fromJson(e.data()))
          .toList();
      return _ecActivities;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<ExtracurricularActivity>> getECActivitiesBySchool(
      String schoolId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('ecActivities')
          .where('schoolId', isEqualTo: schoolId)
          .get();

      _ecActivities = snapshot.docs
          .map((e) => ExtracurricularActivity.fromJson(e.data()))
          .toList();

      return _ecActivities;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateECActivity(ExtracurricularActivity ecActivity) async {
    try {
      await _firebaseFirestore
          .collection('ecActivities')
          .doc(ecActivity.id)
          .update(ecActivity.toJson());

      notifyListeners();
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<void> isDoneECActivity(ExtracurricularActivity ecActivity) async {
    try {
      await _firebaseFirestore
          .collection('ecActivities')
          .doc(ecActivity.id)
          .update({'isDone': ecActivity.isDone});
      notifyListeners();
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<void> addMonitorToEC(
      {required String ecActivityId, required String monitorId}) async {
    try {
      await _firebaseFirestore
          .collection('ecActivities')
          .doc(ecActivityId)
          .update({'monitorId': monitorId});
      notifyListeners();
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<List<ExtracurricularActivity>> getEcActivityByMonitorId(
      String monitorId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('ecActivities')
          .where('monitorsId', arrayContains: monitorId)
          .get();
      _ecActivities = snapshot.docs
          .map((e) => ExtracurricularActivity.fromJson(e.data()))
          .toList();
      notifyListeners();
      return _ecActivities;
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<void> deleteECActivity(ExtracurricularActivity ecActivity) async {
    await _firebaseFirestore
        .collection('ecActivities')
        .doc(ecActivity.id)
        .delete();
    notifyListeners();
  }
}
