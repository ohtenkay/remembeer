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
      ? const TimeOfDay(hour: 6, minute: 0)
      : const TimeOfDayConverter().fromJson(
          json['endOfDayBoundary'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'defaultDrinkType': instance.defaultDrinkType.toJson(),
      'defaultDrinkSize': instance.defaultDrinkSize,
      'endOfDayBoundary': const TimeOfDayConverter().toJson(
        instance.endOfDayBoundary,
      ),
    };
