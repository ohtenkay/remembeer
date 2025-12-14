import 'package:flutter/material.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink/widget/drink_card.dart';
import 'package:remembeer/drink/widget/midnight_divider.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/widget/session_divider.dart';

const _sessionBackgroundColor = Color(0x1A4CAF50);
const _sessionDragOverColor = Color(0x334CAF50);
const _noSessionMinHeight = 120.0;

/// A unified widget that displays a group of drinks.
///
/// When [session] is provided, displays drinks within that session with a
/// background and a [SessionDivider] at the bottom.
///
/// When [session] is null, displays drinks without a session with a
/// transparent background and a minimum height for easy drag-and-drop.
class DrinkGroupSection extends StatefulWidget {
  final Session? session;
  final List<Drink> drinks;

  const DrinkGroupSection({
    super.key,
    required this.session,
    required this.drinks,
  });

  @override
  State<DrinkGroupSection> createState() => _DrinkGroupSectionState();
}

class _DrinkGroupSectionState extends State<DrinkGroupSection> {
  final _drinkService = get<DrinkService>();
  var _isDragOver = false;

  bool get _isSessionMode => widget.session != null;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Drink>(
      onWillAcceptWithDetails: (details) {
        final willAccept = _shouldAcceptDrink(details.data);
        if (willAccept && !_isDragOver) {
          setState(() => _isDragOver = true);
        }
        return willAccept;
      },
      onLeave: (_) => setState(() => _isDragOver = false),
      onAcceptWithDetails: (details) async {
        setState(() => _isDragOver = false);
        await _drinkService.updateDrinkSession(
          details.data,
          widget.session?.id,
        );
      },
      builder: (context, candidateData, rejectedData) {
        return ColoredBox(
          color: _backgroundColor,
          child: _isSessionMode
              ? _buildSessionContent()
              : _buildNoSessionContent(),
        );
      },
    );
  }

  bool _shouldAcceptDrink(Drink drink) {
    if (_isSessionMode) {
      return drink.sessionId != widget.session!.id;
    } else {
      return drink.sessionId != null;
    }
  }

  Color get _backgroundColor {
    if (_isSessionMode) {
      return _isDragOver ? _sessionDragOverColor : _sessionBackgroundColor;
    } else {
      return _isDragOver
          ? Theme.of(context).colorScheme.surfaceContainerHighest
          : Colors.transparent;
    }
  }

  Widget _buildSessionContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.drinks.isEmpty)
          const SizedBox(height: 16)
        else
          ..._buildDrinkItems(),
        SessionDivider(session: widget.session!),
      ],
    );
  }

  Widget _buildNoSessionContent() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _noSessionMinHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildDrinkItems(),
      ),
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
