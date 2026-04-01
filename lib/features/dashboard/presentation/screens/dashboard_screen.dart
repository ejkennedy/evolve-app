import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../goals/data/models/goal.dart';
import '../../../goals/presentation/providers/goals_provider.dart';
import '../../../habits/data/models/habit.dart';
import '../../../habits/presentation/providers/habits_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final goals = ref.watch(activeGoalsProvider);
    final habitsAsync = ref.watch(habitsProvider);

    final greeting = _greeting();
    final name = user?.displayName?.split(' ').first ?? 'there';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceMuted,
              ),
            ),
            Text(name, style: context.textTheme.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(RouteConstants.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(goalsProvider.notifier).refresh();
          ref.read(habitsProvider.notifier).refresh();
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              sliver: SliverList.list(
                children: [
                  if (goals.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Active Goals',
                      action: 'See all',
                      onActionTap: () => context.go(RouteConstants.goals),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 140,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: goals.take(5).length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: AppSpacing.md),
                        itemBuilder: (_, i) =>
                            _GoalProgressCard(goal: goals[i]),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  habitsAsync.when(
                    loading: () => const _HabitsSectionSkeleton(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (habits) {
                      if (habits.isEmpty) return const _EmptyHabitsCard();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(
                            title: "Today's Habits",
                            action: 'Manage',
                            onActionTap: () =>
                                context.go(RouteConstants.habits),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ...habits.map(
                            (h) => _HabitTodayTile(
                              habit: h,
                              isCompleted:
                                  ref.read(habitsProvider.notifier).isCompletedToday(h.id),
                              onTap: () => ref
                                  .read(habitsProvider.notifier)
                                  .logCompletion(h.id),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _CoachPromptCard(
                    onTap: () => context.go(RouteConstants.coach),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onActionTap;

  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: context.textTheme.titleMedium),
        TextButton(onPressed: onActionTap, child: Text(action)),
      ],
    );
  }
}

class _GoalProgressCard extends StatelessWidget {
  final Goal goal;
  const _GoalProgressCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    final progress =
        goal.targetValue > 0 ? goal.currentValue / goal.targetValue : 0.0;
    final color = _categoryColor(goal.category);

    return Container(
      width: 140,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation(color),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            goal.title,
            style: context.textTheme.titleSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            style: context.textTheme.headlineSmall?.copyWith(color: color),
          ),
          Text(
            '${goal.currentValue.toStringAsFixed(0)} / ${goal.targetValue.toStringAsFixed(0)} ${goal.unit}',
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _categoryColor(GoalCategory cat) => switch (cat) {
        GoalCategory.health => AppColors.health,
        GoalCategory.career => AppColors.career,
        GoalCategory.relationships => AppColors.relationships,
        GoalCategory.finance => AppColors.finance,
        GoalCategory.personal => AppColors.personal,
      };
}

class _HabitTodayTile extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;
  final VoidCallback onTap;

  const _HabitTodayTile({
    required this.habit,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Text(
          habit.iconEmoji ?? '✅',
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          habit.title,
          style: context.textTheme.titleSmall?.copyWith(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? AppColors.onSurfaceMuted : null,
          ),
        ),
        subtitle: Text(
          habit.frequency.name,
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.onSurfaceMuted,
          ),
        ),
        trailing: GestureDetector(
          onTap: isCompleted ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? AppColors.success
                  : Colors.transparent,
              border: Border.all(
                color: isCompleted
                    ? AppColors.success
                    : AppColors.onSurfaceMuted,
                width: 2,
              ),
            ),
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
        ),
      ),
    );
  }
}

class _CoachPromptCard extends StatelessWidget {
  final VoidCallback onTap;
  const _CoachPromptCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primaryLight,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Talk to your coach',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Get personalised guidance based on your progress',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHabitsCard extends StatelessWidget {
  const _EmptyHabitsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Icon(Icons.repeat, size: 40, color: AppColors.onSurfaceMuted),
            const SizedBox(height: AppSpacing.sm),
            Text('No habits yet', style: context.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Add your first habit to start tracking',
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitsSectionSkeleton extends StatelessWidget {
  const _HabitsSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (_) => Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: const ListTile(
            leading: SizedBox(width: 24, height: 24),
            title: SizedBox(height: 14),
          ),
        ),
      ),
    );
  }
}
