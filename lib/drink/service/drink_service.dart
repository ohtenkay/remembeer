import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/drink/model/drink.dart';

class DrinkService {
  final _drinkCollection = FirebaseFirestore.instance
      .collection('drinks')
      .withConverter(
        fromFirestore: (snapshot, options) {
          final json = snapshot.data() ?? {};
          json['id'] = snapshot.id;
          return Drink.fromJson(json);
        },
        toFirestore: (value, options) {
          final json = value.toJson();
          json.remove('id');
          return json;
        },
      );

  Stream<List<Drink>> get drinksStream => _drinkCollection.snapshots().map(
    (querySnapshot) =>
        querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList(),
  );

  Future<void> createDrink(Drink drink) {
    return _drinkCollection.add(drink);
  }
}
