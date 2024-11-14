// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/RestaurantTable.dart'; // Assurez-vous que le chemin est correct

// class TableService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<RestaurantTable>> fetchTables() async {
//     // Récupération des tables
//     QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('tables').get();
    
//     // Conversion des données en liste d'objets RestaurantTable
//     return snapshot.docs.map((doc) {
//       return RestaurantTable.fromFirestore(doc.data(), doc.id);
//     }).toList();
//   }

//   Future<void> addTable(RestaurantTable table) {
//     return _firestore.collection('tables').add(table.toMap());
//   }

//   Future<void> updateTable(RestaurantTable table) {
//     return _firestore.collection('tables').doc(table.id).update(table.toMap());
//   }

//   Future<void> deleteTable(String id) {
//     return _firestore.collection('tables').doc(id).delete();
//   }
// }