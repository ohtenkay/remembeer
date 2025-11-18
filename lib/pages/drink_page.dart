import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/widget/drink_form_page.dart';
import 'package:remembeer/drink/widget/drink_list.dart';

class DrinkPage extends StatelessWidget {
  const DrinkPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(
              context,
            ).push(
              MaterialPageRoute<void>(
                builder: (context) => DrinkFormPage(),
              ),
            ),
        child: Icon(Icons.add),
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
