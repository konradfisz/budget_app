import 'package:cloud_firestore/cloud_firestore.dart';

class Result {
  final int id;
  final String score;
  final DocumentReference reference;

  Result.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['score'] != null),
        assert(map['id'] != null),
        score = map['score'],
        id = map['id'];

  Result.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Result<$id:$score>";
}
