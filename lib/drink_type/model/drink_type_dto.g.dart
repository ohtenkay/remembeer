// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_type_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrinkTypeDTO _$DrinkTypeDTOFromJson(Map<String, dynamic> json) => DrinkTypeDTO(
  name: json['name'] as String,
  category: $enumDecode(_$DrinkCategoryEnumMap, json['category']),
  alcoholPercentage: (json['alcoholPercentage'] as num).toDouble(),
);

Map<String, dynamic> _$DrinkTypeDTOToJson(DrinkTypeDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': _$DrinkCategoryEnumMap[instance.category],
      'alcoholPercentage': instance.alcoholPercentage,
    };

const _$DrinkCategoryEnumMap = {DrinkCategory.Beer: 'Beer'};
