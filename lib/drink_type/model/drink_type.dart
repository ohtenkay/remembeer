import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';

part 'drink_type.g.dart';

@JsonSerializable()
class DrinkType {
  final String? id;
  final String name;
  final DrinkCategory category;
  final double alcoholPercentage;

  const DrinkType({
    this.id,
    required this.name,
    required this.category,
    required this.alcoholPercentage,
  });

  factory DrinkType.fromJson(Map<String, dynamic> json) =>
      _$DrinkTypeFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkTypeToJson(this);
}
