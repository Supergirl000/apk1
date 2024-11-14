// class MenuItem {
//   final String id;
//   final String name;
//   final double price;

//   MenuItem({
//     required this.id,
//     required this.name,
//     required this.price,
//   });
// }

class OrderItem {
  String itemName;
  int quantity;
  double pricePerUnit;
  String? selectedItem;

  OrderItem({
    required this.itemName,
    required this.quantity,
    required this.pricePerUnit,
    this.selectedItem,
  });

  double get totalPrice => quantity * pricePerUnit;

  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'quantity': quantity,
      'pricePerUnit': pricePerUnit,
      'selectedItem': selectedItem,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map, String itemId) {
    return OrderItem(
      itemName: map['itemName'] ?? '',
      quantity: map['quantity'] ?? 0,
      pricePerUnit: (map['pricePerUnit'] ?? 0.0).toDouble(),
      selectedItem: map['selectedItem'],
    );
  }
}