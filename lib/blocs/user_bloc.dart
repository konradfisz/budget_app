import 'dart:async';
import 'package:budgetapp/repository.dart';
import 'package:budgetapp/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final _repository = Repository();

  Stream<QuerySnapshot> userResults(String userId) {
    return _repository.userResults(userId);
  }

  Future<void> addUser(String userId) {
    return _repository.addUser(userId);
  }

  Stream<DocumentReference> addResult(String userId) {
    return _repository.addResult(userId);
  }

  Stream<void> deleteResult(String userId, String documentId) {
    return _repository.deleteResult(userId, documentId);
  }

  //dispose all open sink
  void dispose() async {
    await _goalMessage.drain();
    _goalMessage.close();
    await _title.drain();
    _title.close();
    await _showProgress.drain();
    _showProgress.close();
  }
}
