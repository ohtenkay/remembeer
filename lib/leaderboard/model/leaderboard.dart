import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/model/entity.dart';
import 'package:remembeer/common/model/timestamp_converter.dart';

part 'leaderboard.g.dart';

@JsonSerializable()
class Leaderboard extends Entity {
  final String name;
  final Set<String> userIds;
  final String inviteCode;

  const Leaderboard({
    required super.id,
    required super.userId,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    required this.name,
    required this.userIds,
    required this.inviteCode,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LeaderboardToJson(this);

  Leaderboard copyWith({String? name, Set<String>? userIds}) {
    return Leaderboard(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      userId: userId,
      inviteCode: inviteCode,

      name: name ?? this.name,
      userIds: userIds ?? this.userIds,
    );
  }
}
