import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:cafetariat/models/reservation_model.dart'; // Import du modèle ReservationModel

class ReservationService {
  final CollectionReference _reservationsCollection =
      FirebaseFirestore.instance.collection('reservations');

  // Créer une nouvelle réservation
  Future<void> createReservation(ReservationModel reservation) async {
    try {
      await _reservationsCollection.add(reservation.toJson());
    } catch (e) {
      throw Exception('Failed to create reservation: $e');
    }
  }

  // Récupérer toutes les réservations
  Future<List<ReservationModel>> getAllReservations() async {
    try {
      // Récupérer tous les documents de la collection
      QuerySnapshot snapshot = await _reservationsCollection.get();
      
      // Mapper les documents Firestore vers des objets ReservationModel
      return snapshot.docs.map((doc) {
        return ReservationModel.fromJson(doc.data() as Map<String, dynamic>)
          ..id = doc.id; // Ajouter l'ID du document à votre modèle
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch reservations: $e');
    }
  }
}
