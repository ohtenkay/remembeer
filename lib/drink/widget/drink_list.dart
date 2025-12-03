import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink/widget/drink_card.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class DrinkList extends StatelessWidget {
  DrinkList({super.key});

  final _drinkService = get<DrinkService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      stream: _drinkService.drinksForSelectedDateStream,
      builder: (context, drinks) {
        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
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
