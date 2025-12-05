import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/action/drink_notifications.dart';
import 'package:remembeer/drink/page/add_drink_page.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink/widget/date_selector.dart';
import 'package:remembeer/drink/widget/drink_list.dart';
import 'package:remembeer/drink/widget/streak_indicator.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class DrinkPage extends StatelessWidget {
  const DrinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final drinkService = get<DrinkService>();

    return PageTemplate(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreakIndicator(),
          Text('Create session placeholder', style: TextStyle(fontSize: 12)),
        ],
      ),
      padding: EdgeInsets.zero,
      floatingActionButton: GestureDetector(
        onLongPress: () async {
          // TODO(ohtenkay): Maybe make this react to the current date selection, add to the selected date, not now.
          await drinkService.addDefaultDrink();
          if (context.mounted) {
            showDefaultDrinkAdded(context);
          }
        },
        child: FloatingActionButton(
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (context) => AddDrinkPage())),
          child: const Icon(Icons.add),
        ),
      ),
      child: Column(children: [DateSelector(), DrinkList()]),
    );
  }
}
