import 'package:flutter/material.dart';
import 'package:remembeer/common/model/timestamp_converter.dart';

@immutable
abstract class Entity {
  final String id;
  final String userId;
  @TimestampConverter()
  final DateTime? createdAt;
  @TimestampConverter()
  final DateTime? updatedAt;
  @TimestampConverter()
  final DateTime? deletedAt;

  const Entity({
    required this.id,
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson();
}
