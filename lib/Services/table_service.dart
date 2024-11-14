import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafetariat/models/table_model.dart';

class TableService {
  final CollectionReference _tablesCollection =
      FirebaseFirestore.instance.collection('tables');

  Future<List<TableModel>> fetchTables() async {
    try {
      QuerySnapshot querySnapshot = await _tablesCollection.get();
      return querySnapshot.docs
          .map((doc) => TableModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load tables: $e');
    }
  }
}
