import 'package:remembeer/common/model/timestamp_converter.dart';

abstract class Entity {
  final String id;
  @TimestampConverter()
  final DateTime? createdAt;
  @TimestampConverter()
  final DateTime? updatedAt;
  @TimestampConverter()
  final DateTime? deletedAt;

  const Entity({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson();
}
