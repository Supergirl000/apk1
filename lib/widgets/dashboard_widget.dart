import 'package:flutter/material.dart';
import 'package:cafetariat/interfaces/MenuManagementScreen.dart';
import 'package:cafetariat/interfaces/CreateInvoiceScreen.dart' as invoice;
import 'package:cafetariat/interfaces/SalesReportPages.dart' as report;
import 'package:cafetariat/interfaces/PurchaseScreen.dart';
import 'package:cafetariat/interfaces/EmployeeManagement.dart';
// import 'package:cafetariat/interfaces/TableManagementScreen.dart';
import 'package:cafetariat/interfaces/InformationDetailScreen.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  int _selectedIndex = 0;

  void _onFeatureTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuManagementScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => invoice.CreateInvoiceScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  InformationDetailScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PurchaseScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => report.SalesReportPage(
              startDate: DateTime.now().subtract(const Duration(days: 20)),
              endDate: DateTime.now(),
            ),
          ),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmployeeManagement()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.teal,
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  _buildFeatureCard('Menu', Icons.restaurant_menu, 0),
                  _buildFeatureCard('Billing', Icons.receipt, 1),
                  _buildFeatureCard('Table Management', Icons.table_chart, 2),
                  _buildFeatureCard('Orders', Icons.list_alt, 3),
                  _buildFeatureCard('Reports', Icons.bar_chart, 4),
                  _buildFeatureCard('Employees', Icons.person, 5),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardWidget()),
            );
          } else {
            // Navigate to Settings screen (not implemented here)
          }
        },
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, int index) {
    return GestureDetector(
      onTap: () => _onFeatureTapped(index),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 48,
                color: Colors.teal,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
