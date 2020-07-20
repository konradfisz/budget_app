import 'dart:core';

import 'package:budgetapp/clients/auth_client.dart';
import 'package:budgetapp/clients/auth_helpers/auth-result-status.dart';
import 'package:budgetapp/clients/firestore_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repository {
  final _firebaseAuthClient = FirebaseAuthClient();
  final _firestoreClient = FirestoreClient();

  Future<AuthResultStatus> signIn(String email, String password) =>
      _firebaseAuthClient.signIn(email, password);

  Future<AuthResultStatus> signUp(String email, String password) =>
      _firebaseAuthClient.signUp(email, password);

  Future<FirebaseUser> getCurrentUser() => _firebaseAuthClient.getCurrentUser();

  Future<void> signOut() => _firebaseAuthClient.signOut();

  Future<void> sendEmailVerification() =>
      _firebaseAuthClient.sendEmailVerification();

  Future<bool> isEmailVerified() => _firebaseAuthClient.isEmailVerified();

  Stream<QuerySnapshot> myBabies() => _firestoreClient.myBabies();

  Stream<QuerySnapshot> userResults(String userId) =>
      _firestoreClient.userResults(userId);

  Future<void> addUser(String userId) => _firestoreClient.addUser(userId);

  Future<void> addResult(String userId) => _firestoreClient.addResult(userId);
}
