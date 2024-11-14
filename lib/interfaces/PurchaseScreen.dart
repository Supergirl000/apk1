import 'package:flutter/material.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final List<Map<String, dynamic>> _orderItems = [];
  final List<Map<String, dynamic>> _savedOrders = [];
  final TextEditingController _serverNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _selectedItemController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _addItem() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _orderItems.add({
          'selectedItem': _selectedItemController.text,
          'unitPrice': double.parse(_unitPriceController.text),
          'quantity': int.parse(_quantityController.text),
        });
        _clearFields();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _orderItems.removeAt(index);
    });
  }

  void _editItem(int index) {
    final item = _orderItems[index];
    _selectedItemController.text = item['selectedItem'];
    _unitPriceController.text = item['unitPrice'].toString();
    _quantityController.text = item['quantity'].toString();

    // Remove the item to be edited
    _removeItem(index);
  }

  void _saveOrder() {
    if (_serverNameController.text.isNotEmpty && _orderItems.isNotEmpty) {
      setState(() {
        _savedOrders.add({
          'serverName': _serverNameController.text,
          'orderItems': List.from(_orderItems),
        });
        _orderItems.clear();
        _serverNameController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in the server name and add at least one item.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _viewOrders() {
    if (_savedOrders.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewOrdersScreen(savedOrders: _savedOrders),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No orders saved yet.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _clearFields() {
    _selectedItemController.clear();
    _unitPriceController.clear();
    _quantityController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    for (var item in _orderItems) {
      totalAmount += item['unitPrice'] * item['quantity'];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Order'),
        actions: [
          IconButton(
            onPressed: _viewOrders,
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _serverNameController,
                decoration: const InputDecoration(labelText: 'Server Name'),
              ),
              const SizedBox(height: 16),
              const Text('Order Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._orderItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return ListTile(
                  title: Text('${item['selectedItem']}'),
                  subtitle: Text('Prix unitaire: ${item['unitPrice']}€ x Quantité: ${item['quantity']} = ${item['unitPrice'] * item['quantity']}€'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editItem(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeItem(index),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _selectedItemController,
                      decoration: const InputDecoration(labelText: 'Selected Item (e.g., Coffee, Tea)'),
                      validator: (value) => value == null || value.isEmpty ? 'Veuillez saisir un article' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _unitPriceController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Unit Price (€)'),
                      validator: (value) => value == null || value.isEmpty ? 'Veuillez saisir un prix' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      validator: (value) => value == null || value.isEmpty ? 'Veuillez saisir une quantité' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addItem,
                    child: const Text('Add Item'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Total Amount: ${totalAmount.toStringAsFixed(2)}€'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveOrder,
                child: const Text('Save Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _serverNameController.dispose();
    _selectedItemController.dispose();
    _unitPriceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}

class ViewOrdersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> savedOrders;

  const ViewOrdersScreen({Key? key, required this.savedOrders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Orders'),
      ),
      body: ListView.builder(
        itemCount: savedOrders.length,
        itemBuilder: (context, index) {
          final order = savedOrders[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Server Name: ${order['serverName']}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Order Items:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  for (final item in order['orderItems'])
                    ListTile(
                      title: Text(item['selectedItem']),
                      subtitle: Text(
                        'Prix unitaire: ${item['unitPrice']}€ x Quantité: ${item['quantity']} = ${item['unitPrice'] * item['quantity']}€',
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}