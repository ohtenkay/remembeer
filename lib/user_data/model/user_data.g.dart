// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  id: json['id'] as String,
  defaultDrinkType: DrinkType.fromJson(
    json['defaultDrinkType'] as Map<String, dynamic>,
  ),
  defaultDrinkSize: (json['defaultDrinkSize'] as num).toInt(),
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'id': instance.id,
  'defaultDrinkType': instance.defaultDrinkType.toJson(),
  'defaultDrinkSize': instance.defaultDrinkSize,
};
