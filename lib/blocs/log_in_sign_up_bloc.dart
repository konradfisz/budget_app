import 'dart:async';

import 'package:budgetapp/repository.dart';
import 'package:budgetapp/utils/strings.dart';
import 'package:rxdart/rxdart.dart';

class LoginSignupBloc {
  final _repository = Repository();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _isSignedIn = BehaviorSubject<bool>();

  Stream<String> get email => _email.stream.transform(_validateEmail);

  Stream<String> get password => _password.stream.transform(_validatePassword);

  Stream<bool> get signInStatus => _isSignedIn.stream;

  String get emailAddress => _email.value;

  // Change data
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  Function(bool) get showProgressBar => _isSignedIn.sink.add;

  final _validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError(Strings.emailValidateMessage);
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 3) {
      sink.add(password);
    } else {
      sink.addError(Strings.passwordValidateMessage);
    }
  });

  Future<String> singIn() {
    return _repository.signIn(_email.value, _password.value);
  }

  Future<String> signUp() {
    return _repository.signUp(_email.value, _password.value);
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