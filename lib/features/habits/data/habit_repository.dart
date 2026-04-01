import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/providers.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import 'models/habit.dart';
import 'models/habit_log.dart';

class HabitRepository {
  final HiveJsonBox<Habit> _habitBox;
  final HiveJsonBox<HabitLog> _logBox;
  final String _userId;

  HabitRepository(this._habitBox, this._logBox, this._userId);

  List<Habit> getAll() => _habitBox
      .values()
      .where((h) => h.userId == _userId && h.isActive)
      .toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  Habit? getById(String id) => _habitBox.get(id);

  Future<Habit> create({
    required String title,
    String? description,
    required HabitFrequency frequency,
    List<int> targetDays = const [],
    int targetCount = 1,
    required HabitCategory category,
    String? linkedGoalId,
    String? iconEmoji,
    int? colorValue,
  }) async {
    final habit = Habit(
      id: const Uuid().v4(),
      userId: _userId,
      title: title,
      description: description,
      frequency: frequency,
      targetDays: targetDays,
      targetCount: targetCount,
      category: category,
      linkedGoalId: linkedGoalId,
      iconEmoji: iconEmoji,
      colorValue: colorValue,
      createdAt: DateTime.now(),
    );
    await _habitBox.put(habit.id, habit.toJson());
    return habit;
  }

  Future<void> update(Habit habit) async {
    await _habitBox.put(habit.id, habit.toJson());
  }

  Future<void> delete(String id) async {
    final habit = _habitBox.get(id);
    if (habit != null) {
      await _habitBox.put(id, habit.copyWith(isActive: false).toJson());
    }
  }

  Future<HabitLog> logCompletion(String habitId, {String? note}) async {
    final log = HabitLog(
      id: const Uuid().v4(),
      habitId: habitId,
      userId: _userId,
      loggedAt: DateTime.now(),
      note: note,
    );
    await _logBox.put(log.id, log.toJson());
    return log;
  }

  List<HabitLog> getLogsForHabit(String habitId, {int? lastDays}) {
    final logs = _logBox.values().where((l) => l.habitId == habitId);
    if (lastDays != null) {
      final cutoff = DateTime.now().subtract(Duration(days: lastDays));
      return logs
          .where((l) => l.loggedAt.isAfter(cutoff))
          .toList()
        ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    }
    return logs.toList()..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
  }

  bool isCompletedToday(String habitId) {
    final today = DateTime.now();
    return _logBox.values().any((l) =>
        l.habitId == habitId &&
        l.loggedAt.year == today.year &&
        l.loggedAt.month == today.month &&
        l.loggedAt.day == today.day);
  }
}

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final habitBox = ref.watch(habitsBoxProvider);
  final logBox = ref.watch(habitLogsBoxProvider);
  final user = ref.watch(currentUserProvider);
  return HabitRepository(habitBox, logBox, user?.id ?? '');
});
