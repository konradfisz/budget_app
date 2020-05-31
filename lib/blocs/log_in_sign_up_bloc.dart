import 'dart:async';

import 'package:budgetapp/repository.dart';
import 'package:budgetapp/utils/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class LoginSignupBloc {
  final _repository = Repository();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _isSignedIn = BehaviorSubject<bool>();
  final _shouldShowPhoto = BehaviorSubject<bool>.seeded(false);
  final _userId = BehaviorSubject<String>();

  Stream<String> get email => _email.stream.transform(_validateEmail);

  Stream<String> get password => _password.stream.transform(_validatePassword);

  Stream<bool> get isSignedIn =>
      getCurrentUserId().asStream().transform(_isSigned);

  Stream<bool> get shouldShowPhoto => _shouldShowPhoto.stream;

  String get emailAddress => _email.value;

  String get userId => _userId.value;

  // Change data
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  Function(bool) get showPhoto => _shouldShowPhoto.sink.add;

  final _validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email.trim());
    } else {
      sink.addError(Strings.emailValidateMessage);
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 3) {
      sink.add(password.trim());
    } else {
      sink.addError(Strings.passwordValidateMessage);
    }
  });

  final _isSigned =
      StreamTransformer<String, bool>.fromHandlers(handleData: (userId, sink) {
    (userId != null) ? sink.add(true) : sink.add(false);
  });

  Future<String> signIn() {
    return _repository.signIn(_email.value, _password.value);
  }

  Future<String> signUp() {
    return _repository.signUp(_email.value, _password.value);
  }

  Future<String> getCurrentUserId() {
    return _repository
        .getCurrentUser()
        .then((value) => value != null ? value.uid : null);
  }

  Future<String> sendEmailVerification() {
    return _repository.sendEmailVerification();
  }

  // Future<void> isSignedIn() {
  //   return getCurrentUserId().then((userId) => {
  //         (userId != null)
  //             ? _isSignedIn.sink.add(true)
  //             : _isSignedIn.sink.add(false)
  //       });
  // }

  Future<void> signOut() {
    return _repository.signOut().then((_) => _isSignedIn.sink.add(false));
  }

  void dispose() async {
    await _email.drain();
    _email.close();
    await _password.drain();
    _password.close();
    await _isSignedIn.drain();
    _isSignedIn.close();
  }

  bool validateFields() {
    if (_email.value != null &&
        _email.value.isNotEmpty &&
        _password.value != null &&
        _password.value.isNotEmpty &&
        _email.value.contains('@') &&
        _password.value.length > 3) {
      return true;
    } else {
      return false;
    }
  }
}
