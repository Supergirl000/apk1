import 'package:cloud_firestore/cloud_firestore.dart'; // Pour gérer Timestamp (utilisé pour les dates dans Firestore)

class ReservationModel {
  String? id;
  final String name;
  final String phoneNumber;
  final String email;
  final DateTime date;
  final String time;
  final int tableId;
  final int numberOfPersons;
  final String notes;

  ReservationModel({
    this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.date,
    required this.time,
    required this.tableId,
    required this.numberOfPersons,
    required this.notes,
  });

  // Convertir un document Firestore en un objet ReservationModel
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      date: (json['date'] as Timestamp).toDate(),
      time: json['time'],
      tableId: json['tableId'],
      numberOfPersons: json['numberOfPersons'],
      notes: json['notes'],
    );
  }

  // Convertir un objet ReservationModel en JSON pour l'envoyer à Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'date': Timestamp.fromDate(date),
      'time': time,
      'tableId': tableId,
      'numberOfPersons': numberOfPersons,
      'notes': notes,
    };
  }
}
