import 'orderitem.dart';

class Orders {
  final String orderId;
  final int tableNumber;
  final int waiterId;  // Changer le type de String à int
  final String status; // 'pending' or 'completed'
  final double totalAmount;
  final List<OrderItem> items;

  Orders({
    required this.orderId,
    required this.tableNumber,
    required this.waiterId,
    required this.status,
    required this.totalAmount,
    required this.items,
  });

  // Convertir Order en un Map pour le stockage dans Firebase
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'tableNumber': tableNumber,
      'waiterId': waiterId,  // Assurez-vous d'utiliser un entier
      'status': status,
      'totalAmount': totalAmount,
      'items': items.map((item) => item.toMap()).toList(), // Mapper les éléments de commande
    };
  }

  // Convertir un Map en un objet Orders
  factory Orders.fromMap(Map<String, dynamic> map) {
  return Orders(
    orderId: map['orderId'] ?? '',
    tableNumber: map['tableNumber'] ?? 0,
    waiterId: map['waiterId'] ?? 0,  // Ensure waiterId is an int
    status: map['status'] ?? 'pending',
    totalAmount: map['totalAmount']?.toDouble() ?? 0.0,
    items: (map['items'] as List<dynamic>?)
            ?.map((item) => OrderItem.fromMap(item)) // Convert to OrderItem
            .toList() ?? [],
  );
}

}
