import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/providers.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import 'models/goal.dart';

class GoalRepository {
  final HiveJsonBox<Goal> _box;
  final String _userId;

  GoalRepository(this._box, this._userId);

  List<Goal> getAll() => _box
      .values()
      .where((g) => g.userId == _userId)
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Goal> getActive() =>
      getAll().where((g) => g.status == GoalStatus.active).toList();

  Goal? getById(String id) => _box.get(id);

  Future<Goal> create({
    required String title,
    String description = '',
    required GoalCategory category,
    required double targetValue,
    required String unit,
    required DateTime targetDate,
    List<String> tags = const [],
  }) async {
    final goal = Goal(
      id: const Uuid().v4(),
      userId: _userId,
      title: title,
      description: description,
      category: category,
      targetValue: targetValue,
      unit: unit,
      targetDate: targetDate,
      createdAt: DateTime.now(),
      tags: tags,
    );
    await _box.put(goal.id, goal.toJson());
    return goal;
  }

  Future<void> update(Goal goal) async {
    await _box.put(goal.id, goal.copyWith(updatedAt: DateTime.now()).toJson());
  }

  Future<void> updateProgress(String id, double value) async {
    final goal = _box.get(id);
    if (goal == null) return;
    await _box.put(
      id,
      goal
          .copyWith(
            currentValue: value,
            updatedAt: DateTime.now(),
            status: value >= goal.targetValue
                ? GoalStatus.completed
                : goal.status,
          )
          .toJson(),
    );
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final box = ref.watch(goalsBoxProvider);
  final user = ref.watch(currentUserProvider);
  return GoalRepository(box, user?.id ?? '');
});
