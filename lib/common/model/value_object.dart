// Base class for create DTOs that can be serialized to JSON.
// ignore_for_file: one_member_abstracts
abstract class ValueObject {
  Map<String, dynamic> toJson();
}
