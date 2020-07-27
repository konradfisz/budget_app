import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Category {
  final String name;

  Category.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        name = map['name'];

  Category.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);

  @override
  String toString() => "Category<$name:>";
}
