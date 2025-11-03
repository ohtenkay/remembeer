import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';

part 'drink_type_data.g.dart';

@JsonSerializable()
class DrinkTypeData {
  final String name;
  final DrinkCategory category;
  final double alcoholPercentage;

  const DrinkTypeData({
    required this.name,
    required this.category,
    required this.alcoholPercentage,
  });

  factory DrinkTypeData.fromJson(Map<String, dynamic> json) =>
      _$DrinkTypeDataFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkTypeDataToJson(this);
}
