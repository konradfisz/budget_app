import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreClient {
  Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> userResults(String userId) {
    return _firestore
        .collection("users")
        .document(userId)
        .collection("results")
        .snapshots();
  }

  Future<void> addUser(String userId) {
    return _firestore.collection("users").document(userId).setData({
      "id": userId,
      "name": "Roman",
    });
  }

  Stream<void> addResult(String userId) {
    return _firestore
        .collection("users")
        .document(userId)
        .collection("results")
        .add({
      "id": 8,
      "score": "1111111111",
    }).asStream();
  }
}
