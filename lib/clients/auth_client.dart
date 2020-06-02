import 'dart:async';
import 'package:budgetapp/clients/auth_helpers/auth-exception-handler.dart';
import 'package:budgetapp/clients/auth_helpers/auth-result-status.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<AuthResultStatus> signIn(String email, String password);

  Future<AuthResultStatus> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class FirebaseAuthClient implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthResultStatus _status;

  Future<AuthResultStatus> signIn(String email, String password) async {
    try {
      AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> signUp(String email, String password) async {
    try {
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      if (authResult.user != null) {
        FirebaseUser user = authResult.user;
        try {
          await user.sendEmailVerification();
        } catch (e) {
          print(
              "An error occured while trying to send email        verification");
          print(e.message);
        }
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
