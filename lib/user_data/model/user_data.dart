import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';

part 'user_data.g.dart';

@JsonSerializable(explicitToJson: true)
class UserData {
  final String id;

  final DrinkType defaultDrinkType;
  final int defaultDrinkSize;

  const UserData({
    required this.id,
    required this.defaultDrinkType,
    required this.defaultDrinkSize,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  UserData copyWith({
    DrinkType? defaultDrinkType,
    int? defaultDrinkSize,
  }) {
    return UserData(
      id: id,
      defaultDrinkType: defaultDrinkType ?? this.defaultDrinkType,
      defaultDrinkSize: defaultDrinkSize ?? this.defaultDrinkSize,
    );
  }
}
