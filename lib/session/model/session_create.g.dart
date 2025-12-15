// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$SessionCreateToJson(SessionCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'memberIds': instance.memberIds.toList(),
    };
