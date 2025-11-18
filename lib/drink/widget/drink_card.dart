import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/widget/drink_form_page.dart';

class DrinkCard extends StatelessWidget {
  final Drink drink;

  const DrinkCard({super.key, required this.drink});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: DrinkIcon(category: drink.drinkType.category),
        title: Text(
          drink.drinkType.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            _buildInfoRow(
              Icons.calendar_today,
              // TODO(metju-ac): show only time after adding date selector
              DateFormat('dd MMM. yyyy, H:mm').format(drink.consumedAt),
            ),
            const SizedBox(height: 2),
            _buildInfoRow(
              Icons.local_drink,
              '${drink.volumeInMilliliters} ml',
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => DrinkFormPage(drinkToUpdate: drink),
              ),
            );
          },
          icon: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[700]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ],
    );
  }
}
