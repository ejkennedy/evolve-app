import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit.freezed.dart';
part 'habit.g.dart';

enum HabitFrequency {
  @JsonValue('daily')
  daily,
  @JsonValue('weekdays')
  weekdays,
  @JsonValue('weekends')
  weekends,
  @JsonValue('custom')
  custom,
}

enum HabitCategory {
  @JsonValue('health')
  health,
  @JsonValue('mindfulness')
  mindfulness,
  @JsonValue('learning')
  learning,
  @JsonValue('productivity')
  productivity,
  @JsonValue('social')
  social,
  @JsonValue('other')
  other,
}

@freezed
class Habit with _$Habit {
  const factory Habit({
    required String id,
    required String userId,
    required String title,
    String? description,
    @Default(HabitFrequency.daily) HabitFrequency frequency,
    @Default([]) List<int> targetDays,
    @Default(1) int targetCount,
    @Default(HabitCategory.other) HabitCategory category,
    String? linkedGoalId,
    required DateTime createdAt,
    @Default(true) bool isActive,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    String? iconEmoji,
    int? colorValue,
  }) = _Habit;

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);
}
