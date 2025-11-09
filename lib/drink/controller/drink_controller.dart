import 'package:remembeer/common/controller/controller.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_create.dart';

class DrinkController extends Controller<Drink, DrinkCreate> {
  DrinkController(super.authService)
    : super(
        collectionPath: 'drinks',
        fromJson: Drink.fromJson,
      );
}
