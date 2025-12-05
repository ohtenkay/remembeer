import 'package:remembeer/common/controller/controller.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_create.dart';

class DrinkController extends Controller<Drink, DrinkCreate> {
  DrinkController({required super.authService})
    : super(collectionPath: 'drinks', fromJson: Drink.fromJson);

  Stream<List<Drink>> drinksStreamFor(String userId) {
    return readCollection
        .where(deletedAtField, isNull: true)
        .where(userIdField, isEqualTo: userId)
        .snapshots()
        .map(
          (querySnapshot) => List.unmodifiable(
            querySnapshot.docs
                .map((docSnapshot) => docSnapshot.data())
                .toList(),
          ),
        );
  }
}
