import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink/model/drink_dto.dart';

class DrinkService {
  final _drinkReadCollection = FirebaseFirestore.instance
      .collection('drinks')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final json = snapshot.data() ?? {};
          json['id'] = snapshot.id;
          return Drink.fromJson(json);
        },
        toFirestore: (drink, _) => drink.toJson(),
      );

  final _drinkWriteCollection = FirebaseFirestore.instance.collection('drinks');

  Stream<List<Drink>> get drinksStream => _drinkReadCollection
      .where('deletedAt', isNull: true)
      .snapshots()
      .map(
        (querySnapshot) => List.unmodifiable(
          querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList(),
        ),
      );

  Future<void> createDrink(DrinkDTO drinkDTO) {
    final json = drinkDTO.toJson();

    json['createdAt'] = FieldValue.serverTimestamp();
    json['updatedAt'] = FieldValue.serverTimestamp();
    json['deletedAt'] = null;

    return _drinkWriteCollection.add(json);
  }
}
