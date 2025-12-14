import 'package:flutter/material.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink/widget/drink_card.dart';
import 'package:remembeer/drink/widget/midnight_divider.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class NoSessionDropZone extends StatefulWidget {
  final List<Drink> drinks;

  const NoSessionDropZone({super.key, required this.drinks});

  @override
  State<NoSessionDropZone> createState() => _NoSessionDropZoneState();
}

class _NoSessionDropZoneState extends State<NoSessionDropZone> {
  final _drinkService = get<DrinkService>();
  var _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Drink>(
      onWillAcceptWithDetails: (details) {
        final dominated = details.data.sessionId != null;
        if (dominated && !_isDragOver) {
          setState(() => _isDragOver = true);
        }
        return dominated;
      },
      onLeave: (_) => setState(() => _isDragOver = false),
      onAcceptWithDetails: (details) async {
        setState(() => _isDragOver = false);
        await _drinkService.updateDrinkSession(details.data, null);
      },
      builder: (context, candidateData, rejectedData) {
        return ColoredBox(
          color: _isDragOver
              ? Theme.of(context).colorScheme.surfaceContainerHighest
              : Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildDrinkItems(),
          ),
        );
      },
    );
  }

  List<Widget> _buildDrinkItems() {
    if (widget.drinks.isEmpty) {
      return const [];
    }

    final items = <Widget>[];

    for (var i = 0; i < widget.drinks.length; i++) {
      final drink = widget.drinks[i];
      items.add(DrinkCard(drink: drink));

      if (i < widget.drinks.length - 1) {
        final nextDrink = widget.drinks[i + 1];
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
