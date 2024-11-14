import 'package:flutter/material.dart';

import 'order_summary_screen.dart';
import 'package:cafetariat/models/reservation_model.dart';

class InformationDetailScreen extends StatefulWidget {
  const InformationDetailScreen({super.key});

  @override
  _InformationDetailScreenState createState() => _InformationDetailScreenState();
}

class _InformationDetailScreenState extends State<InformationDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  String tableId = '';
  String name = '';
  String phoneNumber = '';
  String email = '';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int numberOfPersons = 1;
  String notes = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _navigateToOrderSummary() {
    if (_formKey.currentState!.validate() && selectedDate != null && selectedTime != null) {
      _formKey.currentState!.save();

      final reservation = ReservationModel(
        tableId: int.parse(tableId),
        name: name,
        phoneNumber: phoneNumber,
        email: email,
        date: selectedDate!,
        time: selectedTime!.format(context),
        numberOfPersons: numberOfPersons,
        notes: notes,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSummaryScreen(reservation: reservation),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Information Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Table Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the table number';
                  }
                  return null;
                },
                onSaved: (value) => tableId = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) => phoneNumber = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => email = value!,
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: Text(selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${selectedDate!.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text(selectedTime == null
                    ? 'Select Time'
                    : 'Time: ${selectedTime!.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Number of persons'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of persons';
                  }
                  return null;
                },
                onSaved: (value) => numberOfPersons = int.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
                onSaved: (value) => notes = value!,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _navigateToOrderSummary,
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
