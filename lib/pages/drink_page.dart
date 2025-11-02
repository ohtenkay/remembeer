import 'package:flutter/material.dart';
import 'package:remembeer/common/beer_icon.dart';

class DrinkPage extends StatelessWidget {
  const DrinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Date Selector Placeholder',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(12.0),
            itemCount: 20,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: BeerIcon(),
                title: Text('Drink Item ${index + 1}'),
                subtitle: Text('Details about Drink Item ${index + 1}'),
                trailing: Icon(Icons.chevron_right),
              );
            },
          ),
        ),
      ],
    );
  }
}
