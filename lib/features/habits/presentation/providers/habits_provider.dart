import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/habit_repository.dart';
import '../../data/models/habit.dart';
import '../../data/models/habit_log.dart';

class HabitsNotifier extends StateNotifier<AsyncValue<List<Habit>>> {
  final HabitRepository _repo;

  HabitsNotifier(this._repo) : super(const AsyncLoading()) {
    _load();
  }

  void _load() {
    try {
      state = AsyncData(_repo.getAll());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> createHabit({
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
    await _repo.create(
      title: title,
      description: description,
      frequency: frequency,
      targetDays: targetDays,
      targetCount: targetCount,
      category: category,
      linkedGoalId: linkedGoalId,
      iconEmoji: iconEmoji,
      colorValue: colorValue,
    );
    _load();
  }

  Future<HabitLog> logCompletion(String habitId, {String? note}) async {
    final log = await _repo.logCompletion(habitId, note: note);
    _load();
    return log;
  }

  Future<void> deleteHabit(String id) async {
    await _repo.delete(id);
    _load();
  }

  bool isCompletedToday(String habitId) => _repo.isCompletedToday(habitId);

  List<HabitLog> getLogsForHabit(String habitId, {int? lastDays}) =>
      _repo.getLogsForHabit(habitId, lastDays: lastDays);

  void refresh() => _load();
}

final habitsProvider =
    StateNotifierProvider<HabitsNotifier, AsyncValue<List<Habit>>>((ref) {
  return HabitsNotifier(ref.watch(habitRepositoryProvider));
});
