import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/model/entity.dart';
import 'package:remembeer/common/model/timestamp_converter.dart';
import 'package:remembeer/drink/model/geopoint_converter.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';

part 'drink.g.dart';

@JsonSerializable(explicitToJson: true)
@GeoPointConverter()
class Drink extends Entity {
  final String userId;
  final DateTime consumedAt;
  final DrinkType drinkType;
  final double volumeInMilliliters;
  final GeoPoint? location;

  Drink({
    required super.id,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    required this.userId,
    required this.consumedAt,
    required this.drinkType,
    required this.volumeInMilliliters,
    this.location,
  });

  factory Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DrinkToJson(this);
}
