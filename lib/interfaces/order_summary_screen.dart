import 'package:flutter/material.dart';

import 'package:cafetariat/models/reservation_model.dart';
import 'package:cafetariat/Services/reservation_service.dart';

class OrderSummaryScreen extends StatelessWidget {
  final ReservationModel reservation;

  OrderSummaryScreen({required this.reservation});

  final ReservationService reservationService = ReservationService();

  Future<void> _confirmReservation(BuildContext context) async {
    try {
      await reservationService.createReservation(reservation);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation confirmed!')),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to confirm reservation: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Summary")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${reservation.name}"),
            Text("Phone Number: ${reservation.phoneNumber}"),
            Text("Email: ${reservation.email}"),
            Text("Date: ${reservation.date.toLocal()}".split(' ')[0]),
            Text("Time: ${reservation.time}"),
            Text("Table ID: ${reservation.tableId}"),
            Text("Number of Persons: ${reservation.numberOfPersons}"),
            Text("Notes: ${reservation.notes}"),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _confirmReservation(context),
              child: Text("Pay and Reserve"),
            ),
          ],
        ),
      ),
    );
  }
}
