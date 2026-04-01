import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../habits/data/models/habit.dart';
import '../../../habits/presentation/providers/habits_provider.dart';

class QuickLogSheet extends ConsumerStatefulWidget {
  const QuickLogSheet({super.key});

  @override
  ConsumerState<QuickLogSheet> createState() => _QuickLogSheetState();
}

class _QuickLogSheetState extends ConsumerState<QuickLogSheet> {
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsProvider);
    final notifier = ref.read(habitsProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.md,
        AppSpacing.pagePadding,
        AppSpacing.md + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.onSurfaceMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Quick Log', style: context.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tap a habit to mark it done',
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          habitsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
            data: (habits) {
              if (habits.isEmpty) {
                return const Center(
                  child: Text('No habits yet — add one first!'),
                );
              }
              return Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: habits.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, i) {
                    final habit = habits[i];
                    final done = notifier.isCompletedToday(habit.id);
                    return _HabitLogTile(
                      habit: habit,
                      isCompleted: done,
                      onTap: done
                          ? null
                          : () async {
                              await notifier.logCompletion(habit.id);
                              if (context.mounted) {
                                context.showSnackBar(
                                    '${habit.title} logged! 🎉');
                              }
                            },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HabitLogTile extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;
  final VoidCallback? onTap;

  const _HabitLogTile({
    required this.habit,
    required this.isCompleted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isCompleted
          ? AppColors.success.withValues(alpha: 0.1)
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          child: Row(
            children: [
              Text(habit.iconEmoji ?? '✨',
                  style: const TextStyle(fontSize: 24)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  habit.title,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isCompleted ? AppColors.onSurfaceMuted : null,
                    decoration:
                        isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              if (isCompleted)
                const Icon(Icons.check_circle, color: AppColors.success)
              else
                Icon(
                  Icons.radio_button_unchecked,
                  color: AppColors.onSurfaceMuted.withValues(alpha: 0.5),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
