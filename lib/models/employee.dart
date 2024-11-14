import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id; // Firestore document ID
  final String name;
  final String position;
  final DateTime hireDate;
  final double performanceRating;
  final String imageUrl; // Nouveau champ pour l'URL de l'image de profil

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.hireDate,
    required this.performanceRating,
    required this.imageUrl, // Inclure l'URL dans le constructeur
  });

  factory Employee.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Employee(
      id: documentId,
      name: data['name'],
      position: data['position'],
      hireDate: (data['hireDate'] as Timestamp).toDate(),
      performanceRating: data['performanceRating'],
      imageUrl: data['imageUrl'] ?? '', // Assurez-vous de gérer le cas où l'URL est nulle
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'hireDate': hireDate,
      'performanceRating': performanceRating,
      'imageUrl': imageUrl, // Ajouter l'URL à la carte
    };
  }
}