import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/drink/constants.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/drink/service/date_service.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/location/service/location_service.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:remembeer/user_settings/model/drink_list_sort.dart';
import 'package:rxdart/rxdart.dart';

class DrinkService {
  final UserSettingsController userSettingsController;
  final DrinkController drinkController;
  final UserController userController;
  final DateService dateService;
  final LocationService locationService;

  DrinkService({
    required this.userSettingsController,
    required this.drinkController,
    required this.userController,
    required this.dateService,
    required this.locationService,
  });

  Stream<List<Drink>> get drinksForSelectedDateStream {
    return Rx.combineLatest3(
      drinkController.userRelatedEntitiesStream,
      dateService.selectedDateStream,
      userSettingsController.userSettingsStream,
      (drinks, selectedDate, userSettings) {
        final drinkListSort = userSettings.drinkListSort;
        final (startTime, endTime) = dateService.selectedDateBoundaries(
          userSettings.endOfDayBoundary,
        );

        final filtered = drinks
            .where(
              (drink) =>
                  drink.consumedAt.isAfter(startTime) &&
                  drink.consumedAt.isBefore(endTime),
            )
            .toList();

        switch (drinkListSort) {
          case DrinkListSort.descending:
            filtered.sort((a, b) => b.consumedAt.compareTo(a.consumedAt));
          case DrinkListSort.ascending:
            filtered.sort((a, b) => a.consumedAt.compareTo(b.consumedAt));
        }

        return filtered;
      },
    );
  }

  Future<void> createDrink(DrinkCreate drinkCreate) async {
    final beers = _beersEquivalent(
      category: drinkCreate.drinkType.category,
      volumeInMilliliters: drinkCreate.volumeInMilliliters,
    );
    final alcohol = _alcoholMl(
      volumeInMilliliters: drinkCreate.volumeInMilliliters,
      alcoholPercentage: drinkCreate.drinkType.alcoholPercentage,
    );

    final user = await userController.currentUser;
    final updatedUser = user.addDrink(
      year: drinkCreate.consumedAt.year,
      month: drinkCreate.consumedAt.month,
      day: drinkCreate.consumedAt.day,
      beersEquivalent: beers,
      alcoholMl: alcohol,
    );

    final batch = drinkController.createBatch();
    drinkController.createSingleInBatch(dto: drinkCreate, batch: batch);
    userController.createOrUpdateInBatch(user: updatedUser, batch: batch);
    await batch.commit();
  }

  Future<void> updateDrink({
    required Drink oldDrink,
    required Drink newDrink,
  }) async {
    final oldBeers = _beersEquivalent(
      category: oldDrink.drinkType.category,
      volumeInMilliliters: oldDrink.volumeInMilliliters,
    );
    final oldAlcohol = _alcoholMl(
      volumeInMilliliters: oldDrink.volumeInMilliliters,
      alcoholPercentage: oldDrink.drinkType.alcoholPercentage,
    );
    final newBeers = _beersEquivalent(
      category: newDrink.drinkType.category,
      volumeInMilliliters: newDrink.volumeInMilliliters,
    );
    final newAlcohol = _alcoholMl(
      volumeInMilliliters: newDrink.volumeInMilliliters,
      alcoholPercentage: newDrink.drinkType.alcoholPercentage,
    );

    var user = await userController.currentUser;

    user = user.removeDrink(
      year: oldDrink.consumedAt.year,
      month: oldDrink.consumedAt.month,
      day: oldDrink.consumedAt.day,
      beersEquivalent: oldBeers,
      alcoholMl: oldAlcohol,
    );

    user = user.addDrink(
      year: newDrink.consumedAt.year,
      month: newDrink.consumedAt.month,
      day: newDrink.consumedAt.day,
      beersEquivalent: newBeers,
      alcoholMl: newAlcohol,
    );

    final batch = drinkController.createBatch();
    drinkController.updateSingleInBatch(entity: newDrink, batch: batch);
    userController.createOrUpdateInBatch(user: user, batch: batch);
    await batch.commit();
  }

  Future<void> deleteDrink(Drink drink) async {
    final beers = _beersEquivalent(
      category: drink.drinkType.category,
      volumeInMilliliters: drink.volumeInMilliliters,
    );
    final alcohol = _alcoholMl(
      volumeInMilliliters: drink.volumeInMilliliters,
      alcoholPercentage: drink.drinkType.alcoholPercentage,
    );

    final user = await userController.currentUser;
    final updatedUser = user.removeDrink(
      year: drink.consumedAt.year,
      month: drink.consumedAt.month,
      day: drink.consumedAt.day,
      beersEquivalent: beers,
      alcoholMl: alcohol,
    );

    final batch = drinkController.createBatch();
    drinkController.deleteSingleInBatch(entity: drink, batch: batch);
    userController.createOrUpdateInBatch(user: updatedUser, batch: batch);
    await batch.commit();
  }

  Future<void> addDefaultDrink() async {
    final userSettings = await userSettingsController.currentUserSettings;
    final position = await locationService.getLastPositionIfAllowed();
    final location = position != null
        ? GeoPoint(position.latitude, position.longitude)
        : null;

    await createDrink(
      DrinkCreate(
        consumedAt: DateTime.now(),
        drinkType: userSettings.defaultDrinkType,
        volumeInMilliliters: userSettings.defaultDrinkSize,
        location: location,
      ),
    );
  }

  Future<void> updateDrinkSession(Drink drink, String? sessionId) async {
    if (drink.sessionId == sessionId) return;
    final updatedDrink = sessionId == null
        ? drink.withoutSessionId()
        : drink.copyWith(sessionId: sessionId);
    await drinkController.updateSingle(updatedDrink);
  }

  double _beersEquivalent({
    required DrinkCategory category,
    required int volumeInMilliliters,
  }) {
    if (category != DrinkCategory.beer) return 0;
    return volumeInMilliliters / beerVolumeMl;
  }

  double _alcoholMl({
    required int volumeInMilliliters,
    required double alcoholPercentage,
  }) {
    return volumeInMilliliters * alcoholPercentage / 100;
  }
}
