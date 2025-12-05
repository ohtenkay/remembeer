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
        if (drinks.isEmpty) {
          return Expanded(child: _buildEmptyState(context));
        }

        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
