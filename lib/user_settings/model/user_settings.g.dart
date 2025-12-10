// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
  id: json['id'] as String,
  defaultDrinkType: DrinkType.fromJson(
    json['defaultDrinkType'] as Map<String, dynamic>,
  ),
  defaultDrinkSize: (json['defaultDrinkSize'] as num).toInt(),
  endOfDayBoundary: json['endOfDayBoundary'] == null
      ? defaultEndOfDayBoundary
      : const TimeOfDayConverter().fromJson(
          json['endOfDayBoundary'] as Map<String, dynamic>,
        ),
  drinkListSort:
      $enumDecodeNullable(_$DrinkListSortEnumMap, json['drinkListSort']) ??
      DrinkListSort.descending,
);

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'defaultDrinkType': instance.defaultDrinkType.toJson(),
      'defaultDrinkSize': instance.defaultDrinkSize,
      'endOfDayBoundary': const TimeOfDayConverter().toJson(
        instance.endOfDayBoundary,
      ),
      'drinkListSort': _$DrinkListSortEnumMap[instance.drinkListSort]!,
    };

const _$DrinkListSortEnumMap = {
  DrinkListSort.descending: 'descending',
  DrinkListSort.ascending: 'ascending',
};
