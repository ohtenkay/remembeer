import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/action/drink_notifications.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/widget/add_drink_page.dart';
import 'package:remembeer/drink/widget/drink_list.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class DrinkPage extends StatelessWidget {
  const DrinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final drinkController = get<DrinkController>();

    return PageTemplate(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Streak placeholder', style: TextStyle(fontSize: 12)),
          Text(
            'Create session placeholder',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onLongPress: () async {
          await drinkController.addDefaultDrink();
          if (context.mounted) {
            showDefaultDrinkAdded(context);
          }
        },
        child: FloatingActionButton(
          onPressed: () =>
              Navigator.of(
                context,
              ).push(
                MaterialPageRoute<void>(
                  builder: (context) => AddDrinkPage(),
                ),
              ),
          child: const Icon(Icons.add),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Date Selector Placeholder',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          DrinkList(),
        ],
      ),
    );
  }
}
