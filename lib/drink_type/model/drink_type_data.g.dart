// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_type_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrinkTypeData _$DrinkTypeDataFromJson(Map<String, dynamic> json) =>
    DrinkTypeData(
      name: json['name'] as String,
      category: $enumDecode(_$DrinkCategoryEnumMap, json['category']),
      alcoholPercentage: (json['alcoholPercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$DrinkTypeDataToJson(DrinkTypeData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': _$DrinkCategoryEnumMap[instance.category],
      'alcoholPercentage': instance.alcoholPercentage,
    };

const _$DrinkCategoryEnumMap = {DrinkCategory.Beer: 'Beer'};
