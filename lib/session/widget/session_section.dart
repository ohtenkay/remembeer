import 'package:flutter/material.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/widget/drink_card.dart';
import 'package:remembeer/drink/widget/midnight_divider.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/widget/session_divider.dart';

const _sessionBackgroundColor = Color(0x1A4CAF50);

class SessionSection extends StatelessWidget {
  final Session session;
  final List<Drink> drinks;

  const SessionSection({
    super.key,
    required this.session,
    required this.drinks,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _sessionBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (drinks.isEmpty)
            const SizedBox(height: 16)
          else
            ..._buildDrinkItems(),
          SessionDivider(session: session),
        ],
      ),
    );
  }

  List<Widget> _buildDrinkItems() {
    final items = <Widget>[];

    for (var i = 0; i < drinks.length; i++) {
      final drink = drinks[i];
      items.add(DrinkCard(drink: drink));

      if (i < drinks.length - 1) {
        final nextDrink = drinks[i + 1];
        if (_crossesMidnight(drink.consumedAt, nextDrink.consumedAt)) {
          items.add(
            MidnightDivider(
              fromDate: nextDrink.consumedAt,
              toDate: drink.consumedAt,
            ),
          );
        }
      }
    }

    return items;
  }

  bool _crossesMidnight(DateTime later, DateTime earlier) {
    return !DateUtils.isSameDay(later, earlier);
  }
}
