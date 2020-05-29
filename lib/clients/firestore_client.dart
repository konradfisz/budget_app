import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreClient {
  Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> myBabies() {
    return _firestore.collection("babies").snapshots();
  }
}
