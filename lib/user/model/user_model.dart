import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String username;
  late String searchableUsername;
  final String avatarName;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.avatarName = 'jirka_kara.png',
  }) {
    searchableUsername = username.toLowerCase();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? username,
    String? avatarName,
  }) {
    return UserModel(
      id: id,
      email: email,
      username: username ?? this.username,
      avatarName: avatarName ?? this.avatarName,
    );
  }
}
