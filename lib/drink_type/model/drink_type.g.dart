// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrinkType _$DrinkTypeFromJson(Map<String, dynamic> json) => DrinkType(
  id: json['id'] as String?,
  name: json['name'] as String,
  category: $enumDecode(_$DrinkCategoryEnumMap, json['category']),
  alcoholPercentage: (json['alcoholPercentage'] as num).toDouble(),
);

Map<String, dynamic> _$DrinkTypeToJson(DrinkType instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': _$DrinkCategoryEnumMap[instance.category],
  'alcoholPercentage': instance.alcoholPercentage,
};

const _$DrinkCategoryEnumMap = {DrinkCategory.Beer: 'Beer'};
