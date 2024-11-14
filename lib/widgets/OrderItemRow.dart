import 'package:flutter/material.dart';
import 'package:cafetariat/models/MenuItem.dart';
import 'package:cafetariat/models/OrderItem.dart';

class OrderItemRow extends StatelessWidget {
  final OrderItem item;
  final List<MenuItem> menuItems;
  final VoidCallback onRemove;
  final ValueChanged<OrderItem> onChanged;
  final ValueChanged<String?> onSelectedItemChanged;

  const OrderItemRow({
    Key? key,
    required this.item,
    required this.menuItems,
    required this.onRemove,
    required this.onChanged,
    required this.onSelectedItemChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: item.selectedItem,
          hint: const Text('Select Item'),
          items: menuItems.map((menuItem) {
            return DropdownMenuItem<String>(
              value: menuItem.id,
              child: Text(menuItem.name),
            );
          }).toList(),
          onChanged: (selectedItemId) {
            onSelectedItemChanged(selectedItemId);
          },
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle, color: Colors.red),
          onPressed: onRemove,
        ),
      ],
    );
  }

  void _showMenuItemPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final menuItem = menuItems[index];
            return ListTile(
              title: Text(menuItem.name),
              onTap: () {
                onSelectedItemChanged(menuItem.id);
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
    );
  }
}