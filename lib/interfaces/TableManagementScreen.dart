// import 'package:flutter/material.dart';
// import 'package:cafetariat/models/tableService.dart';
// import 'package:cafetariat/models/RestaurantTable.dart';

// class TableManagementScreen extends StatefulWidget {
//   const TableManagementScreen({super.key});

//   @override
//   _TableManagementScreenState createState() => _TableManagementScreenState();
// }

// class _TableManagementScreenState extends State<TableManagementScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _capacityController = TextEditingController();
//   bool _isOccupied = false;

//   final TableService _tableService = TableService();
//   List<RestaurantTable> _tables = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchTables();
//   }

//   void _fetchTables() async {
//     final tables = await _tableService.fetchTables();
//     setState(() {
//       _tables = tables;
//     });
//   }

//   void _addTable() {
//     if (_formKey.currentState!.validate()) {
//       final newTable = RestaurantTable(
//         id: '', // Firestore générera l'ID
//         name: _nameController.text,
//         capacity: int.parse(_capacityController.text),
//         isOccupied: _isOccupied,
//       );
//       _tableService.addTable(newTable).then((_) {
//         _clearForm();
//         _fetchTables();
//       });
//     }
//   }

//   void _deleteTable(String id) {
//     _tableService.deleteTable(id).then((_) {
//       _fetchTables();
//     });
//   }

//   void _clearForm() {
//     _nameController.clear();
//     _capacityController.clear();
//     setState(() {
//       _isOccupied = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Table Management'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Form(
//               key: _formKey,
//               child: Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         controller: _nameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Table Name',
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a table name';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _capacityController,
//                         decoration: const InputDecoration(
//                           labelText: 'Capacity',
//                           border: OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a capacity';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       SwitchListTile(
//                         title: const Text('Is Occupied'),
//                         value: _isOccupied,
//                         onChanged: (value) {
//                           setState(() {
//                             _isOccupied = value;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: _addTable,
//                         child: const Text('Add Table'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.teal, // Couleur du bouton
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _tables.length,
//                 itemBuilder: (context, index) {
//                   final table = _tables[index];
//                   return Card(
//                     elevation: 2,
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     child: ListTile(
//                       title: Text(
//                         table.name,
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Text(
//                         'Capacity: ${table.capacity}, Occupied: ${table.isOccupied ? "Yes" : "No"}',
//                       ),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () => _deleteTable(table.id),
//                         color: Colors.red,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }