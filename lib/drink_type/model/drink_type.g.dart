// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrinkType _$DrinkTypeFromJson(Map<String, dynamic> json) => DrinkType(
  name: json['name'] as String,
  category: $enumDecode(_$DrinkCategoryEnumMap, json['category']),
  alcoholPercentage: (json['alcoholPercentage'] as num).toDouble(),
  id: json['id'] as String,
  createdAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['createdAt'],
    const TimestampConverter().fromJson,
  ),
  updatedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['updatedAt'],
    const TimestampConverter().fromJson,
  ),
  deletedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['deletedAt'],
    const TimestampConverter().fromJson,
  ),
);

Map<String, dynamic> _$DrinkTypeToJson(DrinkType instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.createdAt,
    const TimestampConverter().toJson,
  ),
  'updatedAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.updatedAt,
    const TimestampConverter().toJson,
  ),
  'deletedAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.deletedAt,
    const TimestampConverter().toJson,
  ),
  'name': instance.name,
  'category': _$DrinkCategoryEnumMap[instance.category],
  'alcoholPercentage': instance.alcoholPercentage,
};

const _$DrinkCategoryEnumMap = {DrinkCategory.Beer: 'Beer'};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
