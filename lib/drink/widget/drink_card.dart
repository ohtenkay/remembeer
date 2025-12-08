import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/page/update_drink_page.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class DrinkCard extends StatelessWidget {
  final Drink drink;

  DrinkCard({super.key, required this.drink});

  final _drinkController = get<DrinkController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: DrinkIcon(category: drink.drinkType.category),
        title: Text(
          drink.drinkType.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            _buildInfoRow(
              Icons.access_time,
              DateFormat('H:mm').format(drink.consumedAt),
            ),
            const SizedBox(height: 2),
            _buildInfoRow(Icons.local_drink, '${drink.volumeInMilliliters} ml'),
          ],
        ),
        trailing: IconButton(
          onPressed: () => _showDeleteConfirmation(context),
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => UpdateDrinkPage(drinkToUpdate: drink),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Drink'),
        content: Text(
          'Are you sure you want to delete this ${drink.drinkType.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _drinkController.deleteSingle(drink);
              Navigator.of(context).pop();
              showDrinkDeleted(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[700]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}
