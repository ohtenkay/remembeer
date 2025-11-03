// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrinkData _$DrinkDataFromJson(Map<String, dynamic> json) => DrinkData(
  userId: json['userId'] as String,
  consumedAt: DateTime.parse(json['consumedAt'] as String),
  drinkType: DrinkType.fromJson(json['drinkType'] as Map<String, dynamic>),
  volumeInMilliliters: (json['volumeInMilliliters'] as num).toDouble(),
  location: _$JsonConverterFromJson<GeoPoint, GeoPoint>(
    json['location'],
    const GeoPointConverter().fromJson,
  ),
);

Map<String, dynamic> _$DrinkDataToJson(DrinkData instance) => <String, dynamic>{
  'userId': instance.userId,
  'consumedAt': instance.consumedAt.toIso8601String(),
  'drinkType': instance.drinkType.toJson(),
  'volumeInMilliliters': instance.volumeInMilliliters,
  'location': _$JsonConverterToJson<GeoPoint, GeoPoint>(
    instance.location,
    const GeoPointConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
