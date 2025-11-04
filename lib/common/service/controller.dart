import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/common/model/entity.dart';
import 'package:remembeer/common/model/value_object.dart';

abstract class Controller<T extends Entity, U extends ValueObject> {
  @protected
  final CollectionReference<T> readCollection;
  @protected
  final CollectionReference<Map<String, dynamic>> writeCollection;

  Controller({
    required String collectionPath,
    required T Function(Map<String, dynamic> json) fromJson,
  }) : writeCollection = FirebaseFirestore.instance.collection(collectionPath),
       readCollection = FirebaseFirestore.instance
           .collection(collectionPath)
           .withConverter(
             fromFirestore: (snapshot, _) {
               final json = snapshot.data() ?? {};
               return fromJson(json.withId(snapshot.id));
             },
             toFirestore: (_, _) =>
                 throw StateError('Invalid write to read only collection'),
           );

  Stream<List<T>> get entitiesStream => readCollection
      .where(deletedAtField, isNull: true)
      .snapshots()
      .map(
        (querySnapshot) => List.unmodifiable(
          querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList(),
        ),
      );

  Future<void> createSingle(U dto) {
    return writeCollection.add(dto.toJson().withServerCreateTimestamps());
  }

  Future<void> deleteSingle(T entity) {
    return writeCollection
        .doc(entity.id)
        .update(entity.toJson().withoutId().withServerDeleteTimestamps());
  }

  Future<void> updateSingle(T entity) {
    return writeCollection
        .doc(entity.id)
        .update(entity.toJson().withoutId().withServerUpdateTimestamp());
  }
}
