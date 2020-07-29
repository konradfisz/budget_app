import 'package:budgetapp/data/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Result {
  final int id;
  final String expense;
  final Timestamp expenseDate;
  final DocumentReference category;

  Result.fromSnapshot(DocumentSnapshot snapshot)
      : expense = snapshot['expense'],
        id = snapshot['id'],
        category = snapshot['category'],
        expenseDate = snapshot['expenseDate'];

  @override
  String toString() => "Result<$id:$expense>";
}
