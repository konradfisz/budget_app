import 'dart:core';

import 'package:budgetapp/clients/auth_client.dart';
import 'package:budgetapp/clients/firestore_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repository {
  final _firebaseAuthClient = FirebaseAuthClient();
  final _firestoreClient = FirestoreClient();

  Future<String> signIn(String email, String password) =>
      _firebaseAuthClient.signIn(email, password);

  Future<String> signUp(String email, String password) =>
      _firebaseAuthClient.signUp(email, password);

  Future<FirebaseUser> getCurrentUser() => _firebaseAuthClient.getCurrentUser();

  Future<void> signOut() => _firebaseAuthClient.signOut();

  Future<void> sendEmailVerification() =>
      _firebaseAuthClient.sendEmailVerification();

  Future<bool> isEmailVerified() => _firebaseAuthClient.isEmailVerified();

  Stream<QuerySnapshot> myBabies() => _firestoreClient.myBabies();
}
