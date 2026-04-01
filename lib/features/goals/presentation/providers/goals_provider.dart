import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/goal_repository.dart';
import '../../data/models/goal.dart';

class GoalsNotifier extends StateNotifier<AsyncValue<List<Goal>>> {
  final GoalRepository _repo;

  GoalsNotifier(this._repo) : super(const AsyncLoading()) {
    _load();
  }

  void _load() {
    try {
      state = AsyncData(_repo.getAll());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> createGoal({
    required String title,
    String description = '',
    required GoalCategory category,
    required double targetValue,
    required String unit,
    required DateTime targetDate,
    List<String> tags = const [],
  }) async {
    await _repo.create(
      title: title,
      description: description,
      category: category,
      targetValue: targetValue,
      unit: unit,
      targetDate: targetDate,
      tags: tags,
    );
    _load();
  }

  Future<void> updateGoal(Goal goal) async {
    await _repo.update(goal);
    _load();
  }

  Future<void> updateProgress(String id, double value) async {
    await _repo.updateProgress(id, value);
    _load();
  }

  Future<void> deleteGoal(String id) async {
    await _repo.delete(id);
    _load();
  }

  void refresh() => _load();
}

final goalsProvider =
    StateNotifierProvider<GoalsNotifier, AsyncValue<List<Goal>>>((ref) {
  return GoalsNotifier(ref.watch(goalRepositoryProvider));
});

final activeGoalsProvider = Provider<List<Goal>>((ref) {
  return ref.watch(goalsProvider).valueOrNull
          ?.where((g) => g.status == GoalStatus.active)
          .toList() ??
      [];
});
