import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';

final get = GetIt.instance;

class IoCContainer {
  IoCContainer._();

  static void initialize() {
    get.registerSingleton(FirebaseAuth.instance);
    get.registerSingleton(AuthService(get<FirebaseAuth>()));
    get.registerSingleton(DrinkController(get<AuthService>()));
  }
}
