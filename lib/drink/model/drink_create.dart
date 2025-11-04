import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/model/value_object.dart';
import 'package:remembeer/drink/model/drink_fields.dart';
import 'package:remembeer/drink/model/geopoint_converter.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';

part 'drink_create.g.dart';

@JsonSerializable(explicitToJson: true, createFactory: false)
@GeoPointConverter()
class DrinkCreate extends ValueObject with DrinkFields {
  DrinkCreate({
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

  @override
  Map<String, dynamic> toJson() => _$DrinkCreateToJson(this);
}
