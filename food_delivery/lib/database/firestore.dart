import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');
  final CollectionReference accounts =
      FirebaseFirestore.instance.collection('accounts');
  final CollectionReference commande =
      FirebaseFirestore.instance.collection('commande');
  final CollectionReference livraison =
      FirebaseFirestore.instance.collection('livraison');
  final CollectionReference restaurants =
      FirebaseFirestore.instance.collection('restaurants');
  final CollectionReference menu =
      FirebaseFirestore.instance.collection('menu');
  final CollectionReference restaurant_menu =
      FirebaseFirestore.instance.collection('restaurant-menu');
  final CollectionReference payments =
      FirebaseFirestore.instance.collection('payments');

  Future<void> addOrders(String orderName) {
    return orders.add({
      'orderName': orderName,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getOrdersStream() {
    final ordersStream =
        orders.orderBy('timestamp', descending: false).snapshots();
    return ordersStream;
  }

  Future<void> deleteOrder(String docId) {
    return orders.doc(docId).delete();
  }
}
