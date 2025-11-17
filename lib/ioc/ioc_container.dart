import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink_type/controller/drink_type_controller.dart';
import 'package:remembeer/user_data/controller/user_data_controller.dart';
import 'package:remembeer/user_data/service/user_data_service.dart';

final get = GetIt.instance;

class IoCContainer {
  IoCContainer._();

  static void initialize() {
    get.registerSingleton(FirebaseAuth.instance);
    get.registerSingleton(AuthService(get<FirebaseAuth>()));
    get.registerSingleton(DrinkController(get<AuthService>()));
    get.registerSingleton(DrinkTypeController(get<AuthService>()));
    get.registerSingleton(UserDataController(authService: get<AuthService>()));
    get.registerSingleton(
      UserDataService(
        authService: get<AuthService>(),
        userDataController: get<UserDataController>(),
      ),
    );
  }
}
