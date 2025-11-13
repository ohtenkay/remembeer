import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/model/entity.dart';
import 'package:remembeer/common/model/timestamp_converter.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';

part 'drink_type.g.dart';

@JsonSerializable()
class DrinkType extends Entity {
  final String name;
  final DrinkCategory category;
  final double alcoholPercentage;

  DrinkType({
    required super.id,
    required super.userId,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    required this.name,
    required this.category,
    required this.alcoholPercentage,
  });

  factory DrinkType.fromJson(Map<String, dynamic> json) =>
      _$DrinkTypeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DrinkTypeToJson(this);

  @override
  bool operator ==(Object other) =>
      other is DrinkType && other.runtimeType == runtimeType && other.id == id;

  @override
  int get hashCode => id.hashCode;

  DrinkType copyWith({
    String? name,
    DrinkCategory? category,
    double? alcoholPercentage,
  }) {
    return DrinkType(
      id: id,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,

      name: name ?? this.name,
      category: category ?? this.category,
      alcoholPercentage: alcoholPercentage ?? this.alcoholPercentage,
    );
  }
}
