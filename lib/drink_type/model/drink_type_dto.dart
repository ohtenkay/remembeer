import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type_fields.dart';

part 'drink_type_dto.g.dart';

@JsonSerializable()
class DrinkTypeDTO with DrinkTypeFields {
  DrinkTypeDTO({
    required String name,
    required DrinkCategory category,
    required double alcoholPercentage,
  }) {
    this.name = name;
    this.category = category;
    this.alcoholPercentage = alcoholPercentage;
  }

  factory DrinkTypeDTO.fromJson(Map<String, dynamic> json) =>
      _$DrinkTypeDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkTypeDTOToJson(this);
}
