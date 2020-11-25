import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService {
  Firestore _firestore = Firestore.instance;
  String ref = 'categories';
  void createCategory({String name, String imageUrl}) {
    var id = Uuid();
    String categoryId = id.v1();

    _firestore
        .collection(ref)
        .document(categoryId)
        .setData({'category': name, 'image': imageUrl}).catchError((e) {
      print(e);
    });
  }

  Future<List<DocumentSnapshot>> getCategories() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });
  deleteData(docId) {
    Firestore.instance
        .collection('categories')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
