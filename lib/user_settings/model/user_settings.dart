import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';

part 'user_settings.g.dart';

@JsonSerializable(explicitToJson: true)
class UserSettings {
  final String id;

  final DrinkType defaultDrinkType;
  final int defaultDrinkSize;

  const UserSettings({
    required this.id,
    required this.defaultDrinkType,
    required this.defaultDrinkSize,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);

  UserSettings copyWith({DrinkType? defaultDrinkType, int? defaultDrinkSize}) {
    return UserSettings(
      id: id,
      defaultDrinkType: defaultDrinkType ?? this.defaultDrinkType,
      defaultDrinkSize: defaultDrinkSize ?? this.defaultDrinkSize,
    );
  }
}
