import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
  });

  // Factory constructor to create a MenuItem from a Firestore DocumentSnapshot
  factory MenuItem.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MenuItem(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num).toDouble(),
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Static method to return an empty MenuItem
  static MenuItem empty() {
    return MenuItem(
      id: '',
      name: '',
      description: '',
      price: 0.0,
      category: '',
      imageUrl: '',
    );
  }
}