import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../goals/data/models/goal.dart';
import '../../../goals/presentation/providers/goals_provider.dart';
import '../../../habits/presentation/providers/habits_provider.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(activeGoalsProvider);
    final habitsNotifier = ref.read(habitsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          _SectionTitle(title: 'Goal Completion Probability'),
          const SizedBox(height: AppSpacing.sm),
          if (goals.isEmpty)
            _EmptyCard(
              icon: Icons.track_changes,
              message: 'Add goals to see completion predictions here.',
            )
          else
            ...goals.map((g) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _CompletionProbabilityCard(goal: g),
                )),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(title: 'Habit Health'),
          const SizedBox(height: AppSpacing.sm),
          _HabitHealthOverview(notifier: habitsNotifier),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(title: 'Weekly Review'),
          const SizedBox(height: AppSpacing.sm),
          _WeeklyReviewCard(),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: context.textTheme.titleMedium);
  }
}

class _CompletionProbabilityCard extends ConsumerWidget {
  final Goal goal;
  const _CompletionProbabilityCard({required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress =
        goal.targetValue > 0 ? goal.currentValue / goal.targetValue : 0.0;
    final daysLeft = goal.targetDate.difference(DateTime.now()).inDays;
    final daysTotal =
        goal.targetDate.difference(goal.createdAt).inDays.clamp(1, 3650);
    final timeProgress = 1 - (daysLeft / daysTotal).clamp(0.0, 1.0);

    // Simple heuristic: are we progressing faster than time is passing?
    final probability =
        daysLeft <= 0 ? (progress >= 1.0 ? 1.0 : 0.0) : progress / timeProgress.clamp(0.01, 1.0);
    final clamped = probability.clamp(0.0, 1.0);

    final color = clamped >= 0.7
        ? AppColors.success
        : clamped >= 0.4
            ? AppColors.warning
            : AppColors.error;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(goal.title, style: context.textTheme.titleSmall),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    '${(clamped * 100).toStringAsFixed(0)}% likely',
                    style: context.textTheme.labelSmall?.copyWith(color: color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(
              value: clamped,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation(color),
              borderRadius: BorderRadius.circular(4),
              minHeight: 6,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              daysLeft > 0
                  ? '$daysLeft days remaining · ${(progress * 100).toStringAsFixed(0)}% complete'
                  : 'Deadline passed',
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceMuted,
              ),
            ),
            if (clamped < AppConstants.lowProbabilityThreshold) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Icon(Icons.warning_amber, color: AppColors.warning, size: 16),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'At current pace you may miss this goal. Talk to your coach for a plan.',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HabitHealthOverview extends ConsumerWidget {
  final dynamic notifier;
  const _HabitHealthOverview({required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsProvider).valueOrNull ?? [];
    if (habits.isEmpty) {
      return _EmptyCard(
        icon: Icons.repeat,
        message: 'Add habits to see your consistency here.',
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          children: habits.map((h) {
            final logs = ref
                .read(habitsProvider.notifier)
                .getLogsForHabit(h.id, lastDays: 7);
            final rate = logs.length / 7.0;
            final color = rate >= 0.7
                ? AppColors.success
                : rate >= 0.4
                    ? AppColors.warning
                    : AppColors.error;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Text(h.iconEmoji ?? '✨',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h.title, style: context.textTheme.bodyMedium),
                        LinearProgressIndicator(
                          value: rate.clamp(0.0, 1.0),
                          backgroundColor: color.withValues(alpha: 0.15),
                          valueColor: AlwaysStoppedAnimation(color),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${logs.length}/7',
                    style: context.textTheme.labelMedium?.copyWith(color: color),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _WeeklyReviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text('AI Weekly Review', style: context.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your personalised weekly review will appear here every Sunday. Keep logging your habits and progress to get the most insightful summary.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyCard({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(icon, color: AppColors.onSurfaceMuted),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
