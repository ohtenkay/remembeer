import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/drink/model/geopoint_converter.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';

part 'drink_data.g.dart';

@JsonSerializable(explicitToJson: true)
@GeoPointConverter()
class DrinkData {
  final String userId;
  final DateTime consumedAt;
  final DrinkType drinkType;
  final double volumeInMilliliters;
  final GeoPoint? location;

  const DrinkData({
    required this.userId,
    required this.consumedAt,
    required this.drinkType,
    required this.volumeInMilliliters,
    this.location,
  });

  factory DrinkData.fromJson(Map<String, dynamic> json) =>
      _$DrinkDataFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkDataToJson(this);
}
