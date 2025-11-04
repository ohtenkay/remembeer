import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/model/entity.dart';
import 'package:remembeer/common/model/timestamp_converter.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type_fields.dart';

part 'drink_type.g.dart';

@JsonSerializable()
class DrinkType extends Entity with DrinkTypeFields {
  DrinkType({
    required super.id,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    required String name,
    required DrinkCategory category,
    required double alcoholPercentage,
  }) {
    this.name = name;
    this.category = category;
    this.alcoholPercentage = alcoholPercentage;
  }

  factory DrinkType.fromJson(Map<String, dynamic> json) =>
      _$DrinkTypeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DrinkTypeToJson(this);
}
