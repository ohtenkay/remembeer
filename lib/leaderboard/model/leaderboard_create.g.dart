// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardCreate _$LeaderboardCreateFromJson(Map<String, dynamic> json) =>
    LeaderboardCreate(
      name: json['name'] as String,
      userIds: (json['userIds'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      inviteCode: json['inviteCode'] as String,
    );

Map<String, dynamic> _$LeaderboardCreateToJson(LeaderboardCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'userIds': instance.userIds.toList(),
      'inviteCode': instance.inviteCode,
    };
