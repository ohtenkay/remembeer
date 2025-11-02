import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/drink/model/geopoint_converter.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';

part 'drink.g.dart';

@JsonSerializable(explicitToJson: true)
@GeoPointConverter()
class Drink {
  final String? id;
  final String userId;
  final DateTime timestamp;
  final DrinkType drink;
  final double volumeInMilliliters;
  final GeoPoint? location;

  const Drink({
    this.id,
    required this.userId,
    required this.timestamp,
    required this.drink,
    required this.volumeInMilliliters,
    this.location,
  });

  factory Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);

  Map<String, dynamic> toJson() => _$DrinkToJson(this);
}
