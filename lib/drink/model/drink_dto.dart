import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/drink/model/drink_fields.dart';
import 'package:remembeer/drink/model/geopoint_converter.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';

part 'drink_dto.g.dart';

@JsonSerializable(explicitToJson: true)
@GeoPointConverter()
class DrinkDTO with DrinkFields {
  DrinkDTO({
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

  factory DrinkDTO.fromJson(Map<String, dynamic> json) =>
      _$DrinkDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkDTOToJson(this);
}
