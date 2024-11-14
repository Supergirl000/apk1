import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee.dart'; // Assurez-vous que le chemin est correct

class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all employees from Firestore
  Future<List<Employee>> fetchEmployees() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('employees').get();
      return snapshot.docs.map((doc) {
        return Employee.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching employees: $e');
    }
  }

  // Add a new employee to Firestore
  Future<void> addEmployee(Employee employee) async {
    try {
      await _firestore.collection('employees').add(employee.toMap());
    } catch (e) {
      throw Exception('Error adding employee: $e');
    }
  }

  // Update an existing employee in Firestore
  Future<void> updateEmployee(Employee employee) async {
    try {
      await _firestore.collection('employees').doc(employee.id).update(employee.toMap());
    } catch (e) {
      throw Exception('Error updating employee: $e');
    }
  }


  // Delete an employee from Firestore
  Future<void> deleteEmployee(String id) async {
    try {
      await _firestore.collection('employees').doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting employee: $e');
    }
  }
  
}