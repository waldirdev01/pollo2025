import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import '../models/app_user.dart';

class AppUserProvider extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore;
  AppUserProvider({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;
  List<AppUser> _appUsers = [];

  List<AppUser> get appUsers => _appUsers;

  set appUsers(List<AppUser> value) {
    _appUsers = value;
    notifyListeners();
  }

  AppUser? _typeUser;

  AppUser? get typeUser => _typeUser;

  set typeUser(AppUser? value) {
    _typeUser = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<List<AppUser>> getAppUsers() async {
    try {
      final snapshot = await _firebaseFirestore.collection('users').get();
      _appUsers = snapshot.docs.map((e) => AppUser.fromJson(e.data())).toList();
      return _appUsers;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> getAppUsersByType(String type) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('users')
          .where('type', isEqualTo: type)
          .get();
      _appUsers = snapshot.docs.map((e) => AppUser.fromJson(e.data())).toList();
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> getMonitora(String id) async {
    if (id != '') {
      final snapshot =
          await _firebaseFirestore.collection('users').doc(id).get();
      _typeUser = AppUser.fromJson(snapshot.data()!);
      notifyListeners();
    }
  }

  Future<void> updateUserType(
      {required String appUserId, required String appUserType}) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(appUserId)
          .update({'type': appUserType});
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<AppUser>> findAppUserInSchools(String id) async {
    try {
      isLoading = true;
      notifyListeners();
      final snapshot = await _firebaseFirestore
          .collection('users')
          .where('schoolId', isEqualTo: id)
          .get();
      _appUsers = snapshot.docs.map((e) => AppUser.fromJson(e.data())).toList();
      return _appUsers;
    } catch (e) {
      throw e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
