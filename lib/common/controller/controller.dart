import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/extension/json_firestore_helper.dart';
import 'package:remembeer/common/model/entity.dart';
import 'package:remembeer/common/model/value_object.dart';

const String globalUserId = 'global';

abstract class Controller<T extends Entity, U extends ValueObject> {
  @protected
  final AuthService authService;

  @protected
  final CollectionReference<T> readCollection;
  @protected
  final CollectionReference<Map<String, dynamic>> writeCollection;

  Controller({
    required this.authService,
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

  void _assertNotGlobal(T entity) {
    if (entity.userId == globalUserId) {
      throw UnsupportedError(
        'Cannot modify a global entity (${entity.id}) from the app.',
      );
    }
  }

  Stream<List<T>> get userRelatedEntitiesStream => readCollection
      .where(deletedAtField, isNull: true)
      .where(userIdField, isEqualTo: authService.authenticatedUser.uid)
      .snapshots()
      .map(
        (querySnapshot) => List.unmodifiable(
          querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList(),
        ),
      );

  Future<void> createSingle(U dto) {
    return writeCollection.add(
      dto.toJson().withServerCreateTimestamps().withUserId(
        authService.authenticatedUser,
      ),
    );
  }

  Future<void> deleteSingle(T entity) {
    _assertNotGlobal(entity);
    return writeCollection
        .doc(entity.id)
        .update(entity.toJson().withoutId().withServerDeleteTimestamps());
  }

  Future<void> updateSingle(T entity) {
    _assertNotGlobal(entity);
    return writeCollection
        .doc(entity.id)
        .update(entity.toJson().withoutId().withServerUpdateTimestamp());
  }
}
