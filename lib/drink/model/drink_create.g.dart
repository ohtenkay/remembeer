// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$DrinkCreateToJson(DrinkCreate instance) =>
    <String, dynamic>{
      'consumedAt': instance.consumedAt.toIso8601String(),
      'drinkType': instance.drinkType.toJson(),
      'volumeInMilliliters': instance.volumeInMilliliters,
      'location': _$JsonConverterToJson<GeoPoint, GeoPoint>(
        instance.location,
        const GeoPointConverter().toJson,
      ),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
