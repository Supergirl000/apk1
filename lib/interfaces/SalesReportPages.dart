import 'package:flutter/material.dart';
 // Importing for date formatting
import 'package:cafetariat/Services/SalesReportService.dart'; // Import the service


class SalesReportPage extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const SalesReportPage({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  _SalesReportPageState createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  late Future<Map<String, dynamic>> _salesReport;

  @override
  void initState() {
    super.initState();
    // Initialize the sales report data
    _salesReport = SalesReportService().getSalesReportByDate(
      widget.startDate,
      widget.endDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Report'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _salesReport,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available.'));
          }

          final data = snapshot.data!;
          double totalSales = data['totalSales'];
          int totalOrders = data['totalOrders'];
          Map<String, double> salesByMenuItem = data['salesByMenuItem'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sales Report from ${widget.startDate.toLocal()} to ${widget.endDate.toLocal()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Total Sales: \$${totalSales.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Total Orders: $totalOrders',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sales by Menu Item:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: salesByMenuItem.length,
                    itemBuilder: (context, index) {
                      String menuItemId = salesByMenuItem.keys.elementAt(index);
                      double sales = salesByMenuItem[menuItemId]!;
                      return ListTile(
                        title: Text(menuItemId),
                        trailing: Text('\$${sales.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
