import 'package:cloud_firestore/cloud_firestore.dart';

class SalesReportService {
  // Récupération des ventes par période (Étape 2)
  Future<Map<String, dynamic>> getSalesReportByDate(DateTime startDate, DateTime endDate) async {
    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    double totalSales = 0;
    int totalOrders = ordersSnapshot.docs.length;
    Map<String, double> salesByMenuItem = {};

    for (var doc in ordersSnapshot.docs) {
      double orderTotal = doc['totalAmount'];
      totalSales += orderTotal;

      List items = doc['items'];
      for (var item in items) {
        String menuItemId = item['menuItemId'];
        double itemPrice = item['price'];
        int quantity = item['quantity'];
        double itemTotal = itemPrice * quantity;

        if (salesByMenuItem.containsKey(menuItemId)) {
          salesByMenuItem[menuItemId] = salesByMenuItem[menuItemId]! + itemTotal;
        } else {
          salesByMenuItem[menuItemId] = itemTotal;
        }
      }
    }

    return {
      'totalSales': totalSales,
      'totalOrders': totalOrders,
      'salesByMenuItem': salesByMenuItem,
    };
  }

  // Récupération des ventes par plat (Étape 3)
  Future<Map<String, double>> getSalesReportByItem() async {
    final ordersSnapshot = await FirebaseFirestore.instance.collection('orders').get();

    Map<String, double> salesByMenuItem = {};

    for (var doc in ordersSnapshot.docs) {
      List items = doc['items'];
      for (var item in items) {
        String menuItemId = item['menuItemId'];
        double itemPrice = item['price'];
        int quantity = item['quantity'];
        double itemTotal = itemPrice * quantity;

        if (salesByMenuItem.containsKey(menuItemId)) {
          salesByMenuItem[menuItemId] = salesByMenuItem[menuItemId]! + itemTotal;
        } else {
          salesByMenuItem[menuItemId] = itemTotal;
        }
      }
    }

    return salesByMenuItem;
  }

  // Affichage du rapport de vente (Étape 4)
  Future<void> showSalesReport() async {
    DateTime startDate = DateTime(2024, 1, 1);  // Début de la période de rapport
    DateTime endDate = DateTime(2024, 1, 31);    // Fin de la période de rapport

    Map<String, dynamic> report = await getSalesReportByDate(startDate, endDate);

    print('Rapport de ventes du ${startDate.toLocal()} au ${endDate.toLocal()}:');
    print('Total des ventes: ${report['totalSales']}');
    print('Nombre total de commandes: ${report['totalOrders']}');
    
    print('\nVentes par plat:');
    Map<String, double> salesByMenuItem = report['salesByMenuItem'];
    salesByMenuItem.forEach((menuItemId, totalSales) {
      print('Plat $menuItemId: $totalSales');
    });
  }
}
