import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_list_data.dart';
import 'package:remembeer/drink/service/drink_list_service.dart';
import 'package:remembeer/drink/widget/drink_card.dart';
import 'package:remembeer/drink/widget/midnight_divider.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/widget/session_section.dart';

class DrinkList extends StatelessWidget {
  DrinkList({super.key});

  final _drinkListService = get<DrinkListService>();

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      stream: _drinkListService.drinkListDataStream,
      builder: (context, data) {
        if (data.drinks.isEmpty && data.sessions.isEmpty) {
          return Expanded(child: _buildEmptyState(context));
        }

        final items = _buildListItems(data);

        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            itemCount: items.length,
            itemBuilder: (context, index) => items[index],
          ),
        );
      },
    );
  }

  List<Widget> _buildListItems(DrinkListData data) {
    final items = <Widget>[];

    final drinksBySessionId = <String?, List<Drink>>{};
    for (final drink in data.drinks) {
      drinksBySessionId.putIfAbsent(drink.sessionId, () => []).add(drink);
    }

    for (final session in data.sessions) {
      final sessionDrinks = drinksBySessionId[session.id] ?? [];
      items.add(SessionSection(session: session, drinks: sessionDrinks));
    }

    final drinksWithoutSession = drinksBySessionId[null] ?? [];
    for (var i = 0; i < drinksWithoutSession.length; i++) {
      final drink = drinksWithoutSession[i];
      items.add(DrinkCard(drink: drink));

      if (i < drinksWithoutSession.length - 1) {
        final nextDrink = drinksWithoutSession[i + 1];
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

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_drinks_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No drinks logged',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add your first drink',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
