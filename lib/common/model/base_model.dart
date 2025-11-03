import 'package:remembeer/common/model/timestamp_converter.dart';

class BaseModel {
  final String id;
  @TimestampConverter()
  final DateTime? createdAt;
  @TimestampConverter()
  final DateTime? updatedAt;
  @TimestampConverter()
  final DateTime? deletedAt;

  const BaseModel({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
}
