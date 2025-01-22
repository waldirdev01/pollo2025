import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';

class AppAuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  AppAuthProvider({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;
  String currentUserType = '';

  AppUser? _appUser;
  AppUser? get appUser => _appUser;
  set appUser(AppUser? value) {
    _appUser = value;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String userType,
    required String cpf,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      _appUser = AppUser(
          id: currentUser.uid,
          name: name,
          email: email,
          type: UserType.newUser,
          phone: phone,
          cpf: cpf);
      await _firebaseFirestore
          .collection('users')
          .doc(currentUser.uid)
          .set(_appUser!.toJson());
      notifyListeners();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      final userDoc =
          await _firebaseFirestore.collection('users').doc(user.uid).get();
      _appUser = AppUser.fromJson(userDoc.data()!);
      currentUserType = _appUser!.type.string;

      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _appUser = null;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      // Exclui os dados do usuário do Firestore
      await _firebaseFirestore
          .collection('users')
          .doc(currentUser.uid)
          .delete();

      // Em seguida, exclui a conta do usuário do Firebase Auth
      await currentUser.delete();

      // Após a exclusão da conta, você pode querer atualizar o estado da aplicação, como fazer logout do usuário.
      _appUser = null;
      notifyListeners();
    }
  }
}
