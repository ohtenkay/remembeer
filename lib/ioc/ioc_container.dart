import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:remembeer/auth/controller/auth_controller.dart';
import 'package:remembeer/drink/service/drink_controller.dart';

final get = GetIt.instance;

class IoCContainer {
  IoCContainer._();

  static void initialize() {
    get.registerSingleton(DrinkController());
    get.registerSingleton(FirebaseAuth.instance);
    get.registerSingleton(AuthController(get<FirebaseAuth>()));
  }
}
