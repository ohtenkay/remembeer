import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String username;
  late String searchableUsername;
  final String avatarName;
  final Set<String> friends;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.avatarName = 'jirka_kara.png',
    this.friends = const {},
  }) {
    searchableUsername = username.toLowerCase();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? username,
    String? avatarName,
    Set<String>? friends,
  }) {
    return UserModel(
      id: id,
      email: email,
      username: username ?? this.username,
      avatarName: avatarName ?? this.avatarName,
      friends: friends ?? this.friends,
    );
  }

  UserModel addFriend(String friendId) {
    final updatedFriends = Set<String>.from(friends)..add(friendId);
    return copyWith(friends: updatedFriends);
  }

  UserModel removeFriend(String friendId) {
    final updatedFriends = Set<String>.from(friends)..remove(friendId);
    return copyWith(friends: updatedFriends);
  }
}
