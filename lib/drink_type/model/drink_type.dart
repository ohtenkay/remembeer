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
}
