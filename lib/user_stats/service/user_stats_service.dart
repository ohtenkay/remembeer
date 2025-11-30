import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/user_stats/model/user_stats.dart';

const _BEER_VOLUME_ML = 500;

class UserStatsService {
  final DrinkController drinkController;

  UserStatsService({
    required this.drinkController,
  });

  Stream<UserStats> _mapDrinksToStats(Stream<List<Drink>> drinksStream) {
    return drinksStream.map((drinks) {
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      final drinksLast30Days = drinks.where((drink) {
        return drink.consumedAt.isAfter(thirtyDaysAgo);
      }).toList();

      final (isStreakActive, streakDays) = _calculateStreak(drinks);

      return UserStats(
        totalBeersConsumed: _calculateEquivalentBeers(drinks),
        totalAlcoholConsumed: _calculateTotalAlcohol(drinks),
        beersConsumedLast30Days: _calculateEquivalentBeers(drinksLast30Days),
        alcoholConsumedLast30Days: _calculateTotalAlcohol(drinksLast30Days),
        streakDays: streakDays,
        isStreakActive: isStreakActive,
      );
    });
  }

  Stream<UserStats> get userStatsStream {
    return _mapDrinksToStats(drinkController.userRelatedEntitiesStream);
  }

  Stream<UserStats> userStatsStreamFor(String userId) {
    return _mapDrinksToStats(drinkController.drinksStreamFor(userId));
  }

  double _calculateEquivalentBeers(List<Drink> drinks) {
    return drinks
        .where((drink) => drink.drinkType.category == DrinkCategory.Beer)
        .fold<double>(
          0.0,
          (sum, beer) => sum + (beer.volumeInMilliliters / _BEER_VOLUME_ML),
        );
  }

  double _calculateTotalAlcohol(List<Drink> drinks) {
    return drinks.fold<double>(
      0.0,
      (sum, drink) =>
          sum +
          (drink.volumeInMilliliters * drink.drinkType.alcoholPercentage / 100),
    );
  }

  (bool, int) _calculateStreak(List<Drink> drinks) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);

    final uniqueDays =
        drinks
            .map(
              (drink) => DateTime(
                drink.consumedAt.year,
                drink.consumedAt.month,
                drink.consumedAt.day,
              ),
            )
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a));

    final isStreakActive = uniqueDays.contains(todayDate);

    var streakDays = 0;
    var expectedDate = isStreakActive
        ? todayDate
        : todayDate.subtract(const Duration(days: 1));

    for (final day in uniqueDays) {
      if (!day.isAtSameMomentAs(expectedDate)) {
        break;
      }

      streakDays++;
      expectedDate = expectedDate.subtract(const Duration(days: 1));
    }

    return (isStreakActive, streakDays);
  }
}
