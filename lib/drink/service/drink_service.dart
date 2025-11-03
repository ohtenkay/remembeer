import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_data.dart';

class DrinkService {
  final _drinkReadCollection = FirebaseFirestore.instance
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

  final _drinkWriteCollection = FirebaseFirestore.instance.collection('drinks');

  Stream<List<Drink>> get drinksStream => _drinkReadCollection
      .where('deletedAt', isNull: true)
      .snapshots()
      .map(
        (querySnapshot) => querySnapshot.docs
            .map((docSnapshot) => docSnapshot.data())
            .toList(),
      );

  Future<void> createDrink(DrinkData drinkData) {
    final json = drinkData.toJson();

    json['createdAt'] = FieldValue.serverTimestamp();
    json['updatedAt'] = FieldValue.serverTimestamp();
    json['deletedAt'] = null;

    return _drinkWriteCollection.add(json);
  }
}
