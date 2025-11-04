import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/drink/service/controller.dart';

class DrinkController extends Controller<Drink, DrinkCreate> {
  DrinkController()
    : super(
        'drinks',
        Drink.fromJson,
      );
}
