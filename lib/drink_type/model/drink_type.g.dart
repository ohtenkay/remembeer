// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrinkType _$DrinkTypeFromJson(Map<String, dynamic> json) => DrinkType(
  id: json['id'] as String,
  userId: json['userId'] as String,
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
  name: json['name'] as String,
  category: $enumDecode(_$DrinkCategoryEnumMap, json['category']),
  alcoholPercentage: (json['alcoholPercentage'] as num).toDouble(),
);

Map<String, dynamic> _$DrinkTypeToJson(DrinkType instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
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
  'category': _$DrinkCategoryEnumMap[instance.category]!,
  'alcoholPercentage': instance.alcoholPercentage,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$DrinkCategoryEnumMap = {
  DrinkCategory.Beer: 'Beer',
  DrinkCategory.Cider: 'Cider',
  DrinkCategory.Cocktail: 'Cocktail',
  DrinkCategory.Spirit: 'Spirit',
  DrinkCategory.Wine: 'Wine',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
