import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/widget/drink_card.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class DrinkList extends StatelessWidget {
  DrinkList({super.key});

  final _drinkController = get<DrinkController>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      stream: _drinkController.userRelatedEntitiesStream,
      builder: (context, drinks) {
        return Expanded(
          child: ListView.builder(
            itemCount: drinks.length,
            itemBuilder: (context, index) {
              final drink = drinks[index];
              return DrinkCard(drink: drink);
            },
          ),
        );
      },
    );
  }
}
