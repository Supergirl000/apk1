import 'OrderItem.dart';

class Invoice {
  String id;
  String clientName;
  List<OrderItem> orderList;
  double total;
  String paymentStatus;
  String paymentMethod;
  DateTime date;

  Invoice({
    required this.id,
    required this.clientName,
    required this.orderList,
    required this.total,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.date,
  });

  // Method to convert an Invoice to a Map (useful for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'clientName': clientName,
      'orderList': orderList.map((orderItem) => orderItem.toMap()).toList(),
      'total': total,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'date': date.toIso8601String(),
    };
  }

  // Method to create an Invoice from a Map (useful when retrieving from Firebase)
  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'], // Ensure this is included in your Firestore data
      clientName: map['clientName'],
      orderList: (map['orderList'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item, item['itemId']))
          .toList(),
      total: (map['total'] ?? 0.0).toDouble(),
      paymentStatus: map['paymentStatus'],
      paymentMethod: map['paymentMethod'],
      date: DateTime.parse(map['date']),
    );
  }
}