import 'package:budgetapp/data/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Result {
  final String id;
  final DocumentReference category;
  final String expense;
  final Timestamp expenseDate;

  Result.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        category = snapshot['category'],
        expense = snapshot['expense'],
        expenseDate = snapshot['expenseDate'];

  @override
  String toString() => "Result<$id:$expense>";
}
