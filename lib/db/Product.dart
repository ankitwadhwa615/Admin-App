import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  Firestore _firestore = Firestore.instance;
  String ref = 'products';
  Future<List<DocumentSnapshot>> getProducts()=>
      _firestore.collection(ref)
          .orderBy("dateTime",descending: true)
          .getDocuments().then((snaps) {
        return snaps.documents;
      });

  void uploadProducts({
    String dateTime,
      String brand,
      String displayName,
      String description,
      String details,
      double currentPrice,
      double oldPrice,
      int quantity,
      String category,
      List sizes,
      List images}) {
    var id = Uuid();
    String productId = id.v1();

    _firestore.collection(ref).document(productId).setData({
      'id': productId,
      'dateTime':dateTime,
      'brand': brand,
      'displayName': displayName,
      'description':description,
      'details':details,
      'currentPrice':currentPrice,
      'oldPrice':oldPrice,
      'quantity':quantity,
      'category':category,
       'images':images,
      'size':sizes,
    }
    );
  }
  deleteData(docId ){
    Firestore.instance.collection('products').document(docId).delete().catchError((e){print(e);});
  }
}
