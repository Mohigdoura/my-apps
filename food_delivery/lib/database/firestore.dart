import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

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
