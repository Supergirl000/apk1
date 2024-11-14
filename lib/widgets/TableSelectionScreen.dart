// import 'package:flutter/material.dart';

// import 'package:cafetariat/interfaces/InformationDetailScreen.dart';

// class TableSelectionScreen extends StatelessWidget {
//   const TableSelectionScreen({super.key});

//   void _onTableSelected(BuildContext context, int tableId) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => InformationDetailScreen(tableId: tableId),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Table'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Replace this with an image of your tables and use GestureDetector for each table
//             Image.asset(
//               'assets/tables_layout.png', // Image of the restaurant tables layout
//               height: 300,
//               width: 300,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _onTableSelected(context, 16), // Example table ID
//               child: const Text('Select Table 16'),
//             ),
//             // You can add more buttons or clickable areas for different tables
//           ],
//         ),
//       ),
//     );
//   }
// }
