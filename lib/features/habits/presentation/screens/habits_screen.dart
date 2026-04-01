import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/habit.dart';
import '../providers/habits_provider.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(RouteConstants.habitNew),
          ),
        ],
      ),
      body: habitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (habits) {
          if (habits.isEmpty) {
            return _EmptyHabitsState(
              onCreateTap: () => context.push(RouteConstants.habitNew),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            itemCount: habits.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (_, i) => _HabitCard(habit: habits[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteConstants.habitNew),
        icon: const Icon(Icons.add),
        label: const Text('New Habit'),
      ),
    );
  }
}

class _HabitCard extends ConsumerWidget {
  final Habit habit;
  const _HabitCard({required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(habitsProvider.notifier);
    final isCompleted = notifier.isCompletedToday(habit.id);

    return GestureDetector(
      onTap: () => context.push('/habits/${habit.id}'),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: habit.colorValue != null
                  ? Color(habit.colorValue!).withValues(alpha: 0.15)
                  : AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                habit.iconEmoji ?? '✨',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          title: Text(
            habit.title,
            style: context.textTheme.titleSmall?.copyWith(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted ? AppColors.onSurfaceMuted : null,
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                habit.frequency.name,
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceMuted,
                ),
              ),
              if (habit.currentStreak > 0) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '🔥 ${habit.currentStreak}',
                  style: context.textTheme.bodySmall,
                ),
              ],
            ],
          ),
          trailing: GestureDetector(
            onTap: isCompleted
                ? null
                : () => notifier.logCompletion(habit.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.success : Colors.transparent,
                border: Border.all(
                  color:
                      isCompleted ? AppColors.success : AppColors.onSurfaceMuted,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyHabitsState extends StatelessWidget {
  final VoidCallback onCreateTap;
  const _EmptyHabitsState({required this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.repeat_rounded,
              size: 64,
              color: AppColors.onSurfaceMuted,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('No habits yet', style: context.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Build consistency with daily habits that support your goals.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add),
              label: const Text('Add a Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
