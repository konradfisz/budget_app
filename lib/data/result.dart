import 'package:budgetapp/data/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Result {
  final int id;
  final String score;
  final DocumentReference category;

  Result.fromSnapshot(DocumentSnapshot snapshot)
      : score = snapshot['score'],
        id = snapshot['id'],
        category = snapshot['category'];

  @override
  String toString() => "Result<$id:$score>";
}
