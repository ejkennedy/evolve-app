import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_log.freezed.dart';
part 'habit_log.g.dart';

@freezed
class HabitLog with _$HabitLog {
  const factory HabitLog({
    required String id,
    required String habitId,
    required String userId,
    required DateTime loggedAt,
    @Default(1) int count,
    String? note,
    @Default(false) bool synced,
  }) = _HabitLog;

  factory HabitLog.fromJson(Map<String, dynamic> json) =>
      _$HabitLogFromJson(json);
}
