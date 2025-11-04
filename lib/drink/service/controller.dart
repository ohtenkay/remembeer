import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/common/model/entity.dart';
import 'package:remembeer/common/model/value_object.dart';

abstract class Controller<T extends Entity, U extends ValueObject> {
  final CollectionReference<T> _readCollection;
  final CollectionReference<Map<String, dynamic>> _writeCollection;

  Controller(
    String collectionPath,
    T Function(Map<String, dynamic> json) fromJson,
  ) : _writeCollection = FirebaseFirestore.instance.collection(collectionPath),
      _readCollection = FirebaseFirestore.instance
          .collection(collectionPath)
          .withConverter(
            fromFirestore: (snapshot, _) {
              final json = snapshot.data() ?? {};
              return fromJson(json.withId(snapshot.id));
            },
            toFirestore: (_, _) =>
                throw StateError('Invalid write to read only collection'),
          );

  Stream<List<T>> get entitiesStream => _readCollection
      .where(deletedAtField, isNull: true)
      .snapshots()
      .map(
        (querySnapshot) => List.unmodifiable(
          querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList(),
        ),
      );

  Future<void> createSingle(U dto) {
    return _writeCollection.add(dto.toJson().withServerCreateTimestamps());
  }

  Future<void> deleteSingle(T entity) {
    return _writeCollection
        .doc(entity.id)
        .set(entity.toJson().withoutId().withServerDeleteTimestamps());
  }

  Future<void> updateSingle(T entity) {
    return _writeCollection
        .doc(entity.id)
        .set(entity.toJson().withoutId().withServerUpdateTimestamp());
  }
}
