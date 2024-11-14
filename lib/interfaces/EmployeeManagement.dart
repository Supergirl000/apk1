import 'package:flutter/material.dart';
 // Importez le fichier pour afficher la liste des employés
import 'package:cafetariat/Services/employee_service.dart';
import 'package:cafetariat/widgets/EmployeeListScreen.dart';
import 'package:cafetariat/models/employee.dart';
 
// Assurez-vous que le chemin est correct

class EmployeeManagement extends StatefulWidget {
  final Employee? employee; // Ajouter un paramètre pour l'employé à éditer

  EmployeeManagement({this.employee}); // Constructeur

  @override
  _EmployeeManagementState createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController(); // Contrôleur pour l'URL de l'image
  DateTime _hireDate = DateTime.now(); // Date d'embauche par défaut
  double _performanceRating = 5.0; // Note de performance par défaut
  String _selectedPosition = 'Waiter'; // Position par défaut

  final List<String> _positions = ['Waiter', 'Chef', 'Manager']; // Liste des positions

  final EmployeeService _employeeService = EmployeeService();

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _imageUrlController.text = widget.employee!.imageUrl;
      _hireDate = widget.employee!.hireDate;
      _performanceRating = widget.employee!.performanceRating;
      _selectedPosition = widget.employee!.position;
    }
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      final updatedEmployee = Employee(
        id: widget.employee?.id ?? '', // Utiliser l'ID existant
        name: _nameController.text,
        position: _selectedPosition,
        hireDate: _hireDate,
        performanceRating: _performanceRating,
        imageUrl: _imageUrlController.text,
      );

      if (widget.employee == null) {
        // Si c'est un nouvel employé à ajouter
        _employeeService.addEmployee(updatedEmployee).then((_) {
          _clearForm();
          _showSuccessDialog();
        });
      } else {
        // Si c'est un employé existant à mettre à jour
        _employeeService.updateEmployee(updatedEmployee).then((_) {
          _clearForm();
          _showSuccessDialog();
        });
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _imageUrlController.clear();
    _hireDate = DateTime.now();
    _performanceRating = 5.0;
    _selectedPosition = 'Waiter';
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.employee == null ? 'Employee Added' : 'Employee Updated'),
        content: Text('The employee has been ${widget.employee == null ? 'added' : 'updated'} successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToEmployeeList(); // Aller à la liste des employés
            },
            child: Text('View Employees'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _navigateToEmployeeList() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EmployeeListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? 'Add Employee' : 'Edit Employee'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Employee Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPosition,
                decoration: InputDecoration(
                  labelText: 'Position',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                items: _positions.map((position) {
                  return DropdownMenuItem<String>(
                    value: position,
                    child: Text(position),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedPosition = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a position';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Hire Date: ${_hireDate.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Performance Rating: ${_performanceRating.toStringAsFixed(1)}'),
                  Expanded(
                    child: Slider(
                      value: _performanceRating,
                      min: 1.0,
                      max: 5.0,
                      divisions: 4,
                      label: _performanceRating.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          _performanceRating = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEmployee,
                child: Text(widget.employee == null ? 'Add Employee' : 'Update Employee'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _hireDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _hireDate) {
      setState(() {
        _hireDate = picked;
      });
    }
  }
}