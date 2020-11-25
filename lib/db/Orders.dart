import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersService{
  Firestore _firestore = Firestore.instance;
  String  ref='orders';
  Future<List<DocumentSnapshot>> getOrders()=>
      _firestore.collection(ref).orderBy("dateTime",descending: true).getDocuments().then((snaps) {
        return snaps.documents;
      });
  deleteData(id){
    Firestore.instance.collection(ref).document(id).delete().catchError((e){print(e);});

  }
  deleteProducts( {id,index}){
    Firestore.instance.collection('orders').document(id).collection('products').document(index).delete().catchError((e){print(e);});
  }
  Future<List<DocumentSnapshot>> getOrderedProducts(id)=>
      _firestore.collection('orders').document(id).collection('products').getDocuments().then((snaps) {
        return snaps.documents;
      });
}