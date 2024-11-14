import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafetariat/models/Invoice.dart';
import 'package:cafetariat/models/OrderItem.dart';


class CreateInvoiceScreen extends StatefulWidget {
  @override
  _CreateInvoiceScreenState createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final List<OrderItem> _orderItems = [];
  String _paymentStatus = 'Pending';
  String _paymentMethod = 'Cash';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle Facture'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: _generatePdf,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _clientNameController,
                decoration: InputDecoration(labelText: 'Nom du client'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Veuillez entrer le nom du client';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Articles', style: Theme.of(context).textTheme.titleLarge),
              ..._buildOrderItemsList(),
              ElevatedButton(
                onPressed: _addOrderItem,
                child: Text('Ajouter un article'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _paymentStatus,
                decoration: InputDecoration(labelText: 'Statut du paiement'),
                items: ['Paid', 'Pending', 'Cancelled']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _paymentStatus = value!);
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: InputDecoration(labelText: 'Méthode de paiement'),
                items: ['Cash', 'Card', 'Online']
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _paymentMethod = value!);
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveInvoice,
                child: Text('Enregistrer la facture'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrderItemsList() {
    return _orderItems
        .asMap()
        .entries
        .map(
          (entry) => Card(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Nom de l\'article'),
                          onChanged: (value) {
                            setState(() {
                              _orderItems[entry.key] = OrderItem(
                                itemName: value,
                                quantity: _orderItems[entry.key].quantity,
                                pricePerUnit: _orderItems[entry.key].pricePerUnit,
                              );
                            });
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Prix par unité'),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    _orderItems[entry.key] = OrderItem(
                                      itemName: _orderItems[entry.key].itemName,
                                      quantity: _orderItems[entry.key].quantity,
                                      pricePerUnit: double.tryParse(value) ?? 0,
                                    );
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Quantité'),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    _orderItems[entry.key] = OrderItem(
                                      itemName: _orderItems[entry.key].itemName,
                                      quantity: int.tryParse(value) ?? 0,
                                      pricePerUnit: _orderItems[entry.key].pricePerUnit,
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _orderItems.removeAt(entry.key);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  void _addOrderItem() {
    setState(() {
      _orderItems.add(OrderItem(
        itemName: '',
        quantity: 1,
        pricePerUnit: 0,
      ));
    });
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('FACTURE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Client: ${_clientNameController.text}'),
              pw.Text('Date: ${DateTime.now().toString()}'),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Nom de l\'article', 'Prix par unité', 'Quantité', 'Total'],
                data: _orderItems.map((item) => [
                  item.itemName,
                  '${item.pricePerUnit}€',
                  '${item.quantity}',
                  '${item.totalPrice}€',
                ]).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Total: ${_calculateTotal()}€'),
              pw.Text('Statut: $_paymentStatus'),
              pw.Text('Méthode de paiement: $_paymentMethod'),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  double _calculateTotal() {
    return _orderItems.fold(0, (total, item) => total + item.totalPrice);
  }

  void _saveInvoice() async {
    if (_formKey.currentState?.validate() ?? false) {
      final invoice = Invoice(
        id: DateTime.now().toString(), // Générer un vrai ID en production
        clientName: _clientNameController.text,
        orderList: _orderItems,
        total: _calculateTotal(),
        paymentStatus: _paymentStatus,
        paymentMethod: _paymentMethod,
        date: DateTime.now(),
      );

      try {
        // Enregistrer la facture dans Firestore
        final invoiceRef = FirebaseFirestore.instance.collection('invoices').doc(invoice.id);
        await invoiceRef.set({
          'clientName': invoice.clientName,
          'orderList': invoice.orderList.map((item) => {
            'itemName': item.itemName,
            'quantity': item.quantity,
            'pricePerUnit': item.pricePerUnit,
            'amount': item.totalPrice,
          }).toList(),
          'total': invoice.total,
          'paymentStatus': invoice.paymentStatus,
          'paymentMethod': invoice.paymentMethod,
          'date': invoice.date,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Facture enregistrée avec succès')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'enregistrement: $e')),
        );
      }
    }
  }
}
