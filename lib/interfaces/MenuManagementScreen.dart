import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafetariat/models/MenuItem.dart';

class MenuManagementScreen extends StatefulWidget {
  @override
  _MenuManagementScreenState createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final CollectionReference menuItems = FirebaseFirestore.instance.collection('menuItems');

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  String? selectedCategory;

  void _addMenuItem() async {
    String name = nameController.text;
    String description = descriptionController.text;
    double price = double.tryParse(priceController.text) ?? 0.0;
    String category = selectedCategory ?? categoryController.text;
    String imageUrl = imageUrlController.text;

    if (name.isNotEmpty && description.isNotEmpty && category.isNotEmpty) {
      await menuItems.add({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'imageUrl': imageUrl,
      });

      nameController.clear();
      descriptionController.clear();
      priceController.clear();
      categoryController.clear();
      imageUrlController.clear();
      selectedCategory = null; // Reset the selected category
    }
  }

  void _deleteMenuItem(String id) async {
    await menuItems.doc(id).delete();
  }

  void _showAddMenuItemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter un nouvel élément au menu'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: menuItems.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return SizedBox();
                    Set<String> categories = {};
                    snapshot.data!.docs.forEach((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      categories.add(data['category'] ?? 'Uncategorized');
                    });
                    return DropdownButton<String>(
                      hint: Text("Sélectionner une catégorie"),
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    );
                  },
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Ou créez une nouvelle catégorie'),
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(labelText: 'URL de l\'image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _addMenuItem();
                Navigator.of(context).pop();
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion du Menu'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: menuItems.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          // Organiser les éléments par catégorie
          Map<String, List<MenuItem>> categorizedItems = {};
          for (var doc in snapshot.data!.docs) {
            MenuItem menuItem = MenuItem.fromDocument(doc);
            var category = menuItem.category.isNotEmpty ? menuItem.category : 'Uncategorized';
            categorizedItems.putIfAbsent(category, () => []);
            categorizedItems[category]!.add(menuItem);
          }

          return ListView(
            children: categorizedItems.entries.map((entry) {
              String category = entry.key;
              List<MenuItem> items = entry.value;

              return ExpansionTile(
                title: Text(category),
                children: items.map((item) {
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('${item.description} - ${item.price}€'),
                    leading: SizedBox(
                      width: 50, // Set width for the leading widget
                      height: 50, // Set height for the leading widget
                      child: item.imageUrl.isNotEmpty
                          ? Image.network(item.imageUrl, fit: BoxFit.cover)
                          : Icon(Icons.fastfood),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Show confirmation dialog before deletion
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Confirmation de suppression'),
                              content: Text('Êtes-vous sûr de vouloir supprimer cet élément ?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteMenuItem(item.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Supprimer'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenuItemDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
