import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/goal.dart';
import '../providers/goals_provider.dart';

class GoalDetailScreen extends ConsumerWidget {
  final String goalId;
  const GoalDetailScreen({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(goalsProvider).valueOrNull
        ?.firstWhere((g) => g.id == goalId, orElse: () => _notFound());

    if (goal == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final progress =
        goal.targetValue > 0 ? goal.currentValue / goal.targetValue : 0.0;
    final daysLeft = goal.targetDate.difference(DateTime.now()).inDays;

    return Scaffold(
      appBar: AppBar(
        title: Text(goal.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) async {
              if (v == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Delete goal?'),
                    content: const Text('This cannot be undone.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel')),
                      FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete')),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await ref
                      .read(goalsProvider.notifier)
                      .deleteGoal(goal.id);
                  if (context.mounted) context.pop();
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'delete', child: Text('Delete Goal')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}% complete',
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        daysLeft > 0
                            ? '$daysLeft days left'
                            : daysLeft == 0
                                ? 'Due today'
                                : 'Overdue',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: daysLeft > 0
                              ? AppColors.onSurfaceMuted
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor:
                        AppColors.primary.withValues(alpha: 0.2),
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.primary),
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 8,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${goal.currentValue.toStringAsFixed(0)} / ${goal.targetValue.toStringAsFixed(0)} ${goal.unit}',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (goal.description.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About this goal',
                        style: context.textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.sm),
                    Text(goal.description,
                        style: context.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          _LogProgressCard(goal: goal),
          if (goal.aiInsight != null) ...[
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(goal.aiInsight!,
                          style: context.textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Goal _notFound() => Goal(
        id: '',
        userId: '',
        title: 'Goal not found',
        targetDate: DateTime.now(),
        createdAt: DateTime.now(),
      );
}

class _LogProgressCard extends ConsumerStatefulWidget {
  final Goal goal;
  const _LogProgressCard({required this.goal});

  @override
  ConsumerState<_LogProgressCard> createState() => _LogProgressCardState();
}

class _LogProgressCardState extends ConsumerState<_LogProgressCard> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Log Progress', style: context.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ctrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText:
                          'New total (${widget.goal.unit})',
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilledButton(
                  onPressed: () {
                    final v = double.tryParse(_ctrl.text);
                    if (v == null) return;
                    ref.read(goalsProvider.notifier).updateProgress(
                          widget.goal.id,
                          v,
                        );
                    _ctrl.clear();
                  },
                  child: const Text('Log'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
