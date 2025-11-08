import 'package:cloud_firestore/cloud_firestore.dart';

const String idField = 'id';
const String createdAtField = 'createdAt';
const String updatedAtField = 'updatedAt';
const String deletedAtField = 'deletedAt';

extension JsonFirestoreHelper on Map<String, dynamic> {
  Map<String, dynamic> withId(String id) {
    this[idField] = id;
    return this;
  }

  Map<String, dynamic> withoutId() {
    remove(idField);
    return this;
  }

  Map<String, dynamic> withServerCreateTimestamps() {
    this[createdAtField] = FieldValue.serverTimestamp();
    this[updatedAtField] = FieldValue.serverTimestamp();
    this[deletedAtField] = null;
    return this;
  }

  Map<String, dynamic> withServerUpdateTimestamp() {
    this[updatedAtField] = FieldValue.serverTimestamp();
    return this;
  }

  Map<String, dynamic> withServerDeleteTimestamps() {
    this[updatedAtField] = FieldValue.serverTimestamp();
    this[deletedAtField] = FieldValue.serverTimestamp();
    return this;
  }
}
