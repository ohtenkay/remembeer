import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/drink_type/controller/drink_type_controller.dart';
import 'package:remembeer/friend_request/controller/friend_request_controller.dart';
import 'package:remembeer/user/controller/user_controller.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user_settings/controller/user_settings_controller.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';
import 'package:remembeer/user_stats/service/user_stats_service.dart';

final get = GetIt.instance;

class IoCContainer {
  IoCContainer._();

  static void initialize() {
    get.registerSingleton(FirebaseAuth.instance);
    get.registerSingleton(AuthService(firebaseAuth: get<FirebaseAuth>()));
    get.registerSingleton(DrinkController(authService: get<AuthService>()));
    get.registerSingleton(DrinkTypeController(authService: get<AuthService>()));
    get.registerSingleton(
      FriendRequestController(authService: get<AuthService>()),
    );
    get.registerSingleton(UserController(authService: get<AuthService>()));
    get.registerSingleton(
      UserSettingsController(authService: get<AuthService>()),
    );
    get.registerSingleton(
      UserSettingsService(
        authService: get<AuthService>(),
        userSettingsController: get<UserSettingsController>(),
      ),
    );
    get.registerSingleton(
      DrinkService(
        drinkController: get<DrinkController>(),
        userSettingsService: get<UserSettingsService>(),
      ),
    );
    get.registerSingleton(
      UserService(
        authService: get<AuthService>(),
        userController: get<UserController>(),
      ),
    );
    get.registerSingleton(
      UserStatsService(
        drinkController: get<DrinkController>(),
      ),
    );
  }
}
