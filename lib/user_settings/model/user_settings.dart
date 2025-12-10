import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/user_settings/model/drink_list_sort.dart';
import 'package:remembeer/user_settings/model/time_of_day_converter.dart';

part 'user_settings.g.dart';

const defaultEndOfDayBoundary = TimeOfDay(hour: 6, minute: 0);

@JsonSerializable(explicitToJson: true)
class UserSettings {
  final String id;

  final DrinkType defaultDrinkType;
  final int defaultDrinkSize;
  @TimeOfDayConverter()
  final TimeOfDay endOfDayBoundary;
  final DrinkListSort drinkListSort;

  const UserSettings({
    required this.id,
    required this.defaultDrinkType,
    required this.defaultDrinkSize,
    this.endOfDayBoundary = defaultEndOfDayBoundary,
    this.drinkListSort = DrinkListSort.descending,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);

  UserSettings copyWith({
    DrinkType? defaultDrinkType,
    int? defaultDrinkSize,
    TimeOfDay? endOfDayBoundary,
    DrinkListSort? drinkListSort,
  }) {
    return UserSettings(
      id: id,
      defaultDrinkType: defaultDrinkType ?? this.defaultDrinkType,
      defaultDrinkSize: defaultDrinkSize ?? this.defaultDrinkSize,
      endOfDayBoundary: endOfDayBoundary ?? this.endOfDayBoundary,
      drinkListSort: drinkListSort ?? this.drinkListSort,
    );
  }
}
