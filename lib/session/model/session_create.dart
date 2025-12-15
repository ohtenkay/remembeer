import 'package:json_annotation/json_annotation.dart';
import 'package:remembeer/common/model/value_object.dart';

part 'session_create.g.dart';

@JsonSerializable(createFactory: false)
class SessionCreate extends ValueObject {
  final String name;
  final DateTime startedAt;
  final DateTime? endedAt;
  final Set<String> memberIds;

  SessionCreate({
    required this.name,
    required this.startedAt,
    this.endedAt,
    required this.memberIds,
  });

  @override
  Map<String, dynamic> toJson() => _$SessionCreateToJson(this);
}
