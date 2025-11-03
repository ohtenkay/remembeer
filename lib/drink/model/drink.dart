import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/model/base_model.dart';
import 'package:remembeer/common/model/timestamp_converter.dart';
import 'package:remembeer/drink/model/drink_fields.dart';
import 'package:remembeer/drink/model/geopoint_converter.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';

part 'drink.g.dart';

@JsonSerializable(explicitToJson: true)
@GeoPointConverter()
class Drink extends BaseModel with DrinkFields {
  Drink({
    required super.id,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    required String userId,
    required DateTime consumedAt,
    required DrinkType drinkType,
    required double volumeInMilliliters,
    GeoPoint? location,
  }) {
    this.userId = userId;
    this.consumedAt = consumedAt;
    this.drinkType = drinkType;
    this.volumeInMilliliters = volumeInMilliliters;
    this.location = location;
  }

  factory Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkToJson(this);
}
