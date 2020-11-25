import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class SoldProductService {
  Firestore _firestore = Firestore.instance;
  String ref = 'sold';
  Future<List<DocumentSnapshot>> getSoldProducts() => _firestore
      .collection(ref)
      .orderBy("dateTimeOfCompletion",descending: true)
      .getDocuments()
      .then((snaps) {
    return snaps.documents;
  });
  Future<List<DocumentSnapshot>> getOrderedProducts(id)=>
      _firestore.collection(ref).document(id).collection('products').getDocuments().then((snaps) {
        return snaps.documents;
      });
  void uploadSoldProducts(
      {String soldId,
        String brand,
        String category,
        String description,
        String details,
        double currentPrice,
        double oldPrice,
        int quantity,
        String size,
        List images}) {
    var id = Uuid();
    String productId = id.v1();
    _firestore
        .collection(ref)
        .document(soldId)
        .collection('products')
        .document(productId)
        .setData({
      'id':productId,
      'category':category,
      'brand': brand,
      'description': description,
      'details': details,
      'currentPrice': currentPrice,
      'oldPrice': oldPrice,
      'quantity': quantity,
      'images': images,
      'size': size,
    });
  }

  void uploadSoldUsersDetails({
    String dateOfCompletion,
    String monthOfCompletion,
    String yearOfCompletion,
    String dateTimeOfCompletion,
    String orderDateTime,
    String soldId,
    String month,
    String date,
    String year,
    String paymentMethod,
    double totalAmount,
    String name,
    String address,
    String mobileNo,
    String pinCode,
    String locality,
    String city,
    String state,
  }) {

    _firestore.collection(ref).document(soldId).setData({
      'id':soldId,
      'dateOfCompletion':dateOfCompletion,
      'monthOfCompletion':monthOfCompletion,
      'yearOfCompletion':yearOfCompletion,
      'dateTimeOfCompletion':dateTimeOfCompletion,
      'month':month,
      'year': year,
      'date':date,
      'dateTime':orderDateTime,
      'paymentMethod': paymentMethod,
      'totalAmount': totalAmount,
      'name': name,
      'address': address,
      'mobileNo': mobileNo,
      'locality': locality,
      'pinCode': pinCode,
      'city': city,
      'state': state,
    });
  }
}