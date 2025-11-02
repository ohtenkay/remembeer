import 'package:get_it/get_it.dart';
import 'package:remembeer/drink/service/drink_service.dart';

final get = GetIt.instance;

class IoCContainer {
  static void initialize() {
    get.registerSingleton(DrinkService());
  }
}
