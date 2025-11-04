import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/model/value_object.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type_fields.dart';

part 'drink_type_create.g.dart';

@JsonSerializable(createFactory: false)
class DrinkTypeCreate extends ValueObject with DrinkTypeFields {
  DrinkTypeCreate({
    required String name,
    required DrinkCategory category,
    required double alcoholPercentage,
  }) {
    this.name = name;
    this.category = category;
    this.alcoholPercentage = alcoholPercentage;
  }

  @override
  Map<String, dynamic> toJson() => _$DrinkTypeCreateToJson(this);
}
