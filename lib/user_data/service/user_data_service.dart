import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/user_data/controller/user_data_controller.dart';
import 'package:remembeer/user_data/model/user_data.dart';

const _DEFAULT_DRINK = DrinkType(
  id: 'global-beer',
  userId: 'global',
  name: 'Beer',
  category: DrinkCategory.Beer,
  alcoholPercentage: 4.5,
);
const _DEFAULT_DRINK_SIZE = 500;

class UserDataService {
  final AuthService authService;
  final UserDataController userDataController;

  UserDataService({
    required this.authService,
    required this.userDataController,
  });

  Stream<UserData> get userDataStream => userDataController.userDataStream;

  Future<UserData> get getCurrentUserData =>
      userDataController.getCurrentUserData;

  Future<void> createDefaultUserData() async {
    final defaultUserData = UserData(
      id: authService.authenticatedUser.uid,
      defaultDrinkType: _DEFAULT_DRINK,
      defaultDrinkSize: _DEFAULT_DRINK_SIZE,
    );

    await userDataController.createOrUpdateUserData(defaultUserData);
  }

  Future<void> updateDefaultDrinkType(DrinkType drinkType) async {
    final currentUserData = await userDataController.getCurrentUserData;
    if (currentUserData.defaultDrinkType == drinkType) {
      return;
    }

    final updatedUserData = currentUserData.copyWith(
      defaultDrinkType: drinkType,
    );

    await userDataController.createOrUpdateUserData(updatedUserData);
  }

  Future<void> updateDefaultDrinkSize(int drinkSize) async {
    final currentUserData = await userDataController.getCurrentUserData;
    if (currentUserData.defaultDrinkSize == drinkSize) {
      return;
    }

    final updatedUserData = currentUserData.copyWith(
      defaultDrinkSize: drinkSize,
    );

    await userDataController.createOrUpdateUserData(updatedUserData);
  }
}
