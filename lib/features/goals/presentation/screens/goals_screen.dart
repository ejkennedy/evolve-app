import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/goal.dart';
import '../providers/goals_provider.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(RouteConstants.goalNew),
          ),
        ],
      ),
      body: goalsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (goals) {
          if (goals.isEmpty) {
            return _EmptyGoalsState(
              onCreateTap: () => context.push(RouteConstants.goalNew),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            itemCount: goals.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (_, i) => _GoalCard(goal: goals[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteConstants.goalNew),
        icon: const Icon(Icons.add),
        label: const Text('New Goal'),
      ),
    );
  }
}

class _GoalCard extends ConsumerWidget {
  final Goal goal;
  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress =
        goal.targetValue > 0 ? goal.currentValue / goal.targetValue : 0.0;
    final color = _categoryColor(goal.category);
    final daysLeft =
        goal.targetDate.difference(DateTime.now()).inDays;

    return GestureDetector(
      onTap: () => context.push('/goals/${goal.id}'),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
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
                      goal.category.name,
                      style: context.textTheme.labelSmall
                          ?.copyWith(color: color),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    daysLeft > 0 ? '$daysLeft days left' : 'Overdue',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: daysLeft > 0
                          ? AppColors.onSurfaceMuted
                          : AppColors.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(goal.title, style: context.textTheme.titleMedium),
              if (goal.description.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  goal.description,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceMuted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      backgroundColor: color.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation(color),
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${goal.currentValue.toStringAsFixed(0)} / ${goal.targetValue.toStringAsFixed(0)} ${goal.unit}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceMuted,
                ),
              ),
            ],
          ),
        ),
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

class _EmptyGoalsState extends StatelessWidget {
  final VoidCallback onCreateTap;
  const _EmptyGoalsState({required this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.track_changes,
              size: 64,
              color: AppColors.onSurfaceMuted,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('No goals yet', style: context.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Set your first goal and let AI help you break it down into actionable steps.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add),
              label: const Text('Create a Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
