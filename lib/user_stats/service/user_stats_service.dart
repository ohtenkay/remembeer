import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/user_stats//model/user_stats.dart';

const _BEER_VOLUME_ML = 500;

class UserStatsService {
  final DrinkController drinkController;

  UserStatsService({
    required this.drinkController,
  });

  Stream<UserStats> get userStatsStream {
    return drinkController.userRelatedEntitiesStream.map((drinks) {
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      final drinksLast30Days = drinks.where((drink) {
        return drink.consumedAt.isAfter(thirtyDaysAgo);
      }).toList();

      return UserStats(
        totalBeersConsumed: _calculateEquivalentBeers(drinks),
        totalAlcoholConsumed: _calculateTotalAlcohol(drinks),
        beersConsumedLast30Days: _calculateEquivalentBeers(drinksLast30Days),
        alcoholConsumedLast30Days: _calculateTotalAlcohol(drinksLast30Days),
      );
    });
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
}
