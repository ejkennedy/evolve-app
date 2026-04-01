import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

enum GoalCategory {
  @JsonValue('health')
  health,
  @JsonValue('career')
  career,
  @JsonValue('relationships')
  relationships,
  @JsonValue('finance')
  finance,
  @JsonValue('personal')
  personal,
}

enum GoalStatus {
  @JsonValue('active')
  active,
  @JsonValue('paused')
  paused,
  @JsonValue('completed')
  completed,
  @JsonValue('abandoned')
  abandoned,
}

@freezed
class Goal with _$Goal {
  const factory Goal({
    required String id,
    required String userId,
    required String title,
    @Default('') String description,
    @Default(GoalCategory.personal) GoalCategory category,
    @Default(GoalStatus.active) GoalStatus status,
    @Default(0.0) double targetValue,
    @Default(0.0) double currentValue,
    @Default('') String unit,
    required DateTime targetDate,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default([]) List<String> tags,
    String? aiInsight,
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}
