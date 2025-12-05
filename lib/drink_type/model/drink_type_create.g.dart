// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_type_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$DrinkTypeCreateToJson(DrinkTypeCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': _$DrinkCategoryEnumMap[instance.category]!,
      'alcoholPercentage': instance.alcoholPercentage,
    };

const _$DrinkCategoryEnumMap = {
  DrinkCategory.beer: 'beer',
  DrinkCategory.cider: 'cider',
  DrinkCategory.cocktail: 'cocktail',
  DrinkCategory.spirit: 'spirit',
  DrinkCategory.wine: 'wine',
};
