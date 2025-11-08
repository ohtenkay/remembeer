import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/model/value_object.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';

part 'drink_type_create.g.dart';

@JsonSerializable(createFactory: false)
class DrinkTypeCreate extends ValueObject {
  final String name;
  final DrinkCategory category;
  final double alcoholPercentage;

  DrinkTypeCreate({
    required this.name,
    required this.category,
    required this.alcoholPercentage,
  });

  @override
  Map<String, dynamic> toJson() => _$DrinkTypeCreateToJson(this);
}
