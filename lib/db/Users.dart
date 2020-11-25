import'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class UserServices {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String user = "users";
  Firestore _firestore = Firestore.instance;
  String ref= 'user';

  createUser(Map value) {
    _database.reference().child(user).push().set(
        value
    ).catchError((e) =>
    {
      print(e.toString())
    });
  }
  Future<List<DocumentSnapshot>> getUser() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });
}


