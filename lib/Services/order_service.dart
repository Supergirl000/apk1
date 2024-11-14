import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final CollectionReference ordersCollection = FirebaseFirestore.instance.collection('orders');

  Future<void> addOrder(String orderId, List<Map<String, dynamic>> items, double totalAmount) async {
    await ordersCollection.doc(orderId).set({
      'orderId': orderId,
      'items': items,
      'totalAmount': totalAmount,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
