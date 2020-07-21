import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreClient {
  Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> myBabies() {
    return _firestore.collection("baby").snapshots();
  }

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

  Future<void> addResult(String userId) {
    return _firestore
        .collection("users")
        .document(userId)
        .collection("results")
        .add({
      "id": 5,
      "score": "21313",
    });
  }
}
