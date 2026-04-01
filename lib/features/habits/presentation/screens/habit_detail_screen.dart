import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/habit.dart';
import '../../data/models/habit_log.dart';
import '../providers/habits_provider.dart';

class HabitDetailScreen extends ConsumerWidget {
  final String habitId;
  const HabitDetailScreen({super.key, required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habit = ref.watch(habitsProvider).valueOrNull?.firstWhere(
          (h) => h.id == habitId,
          orElse: () => _notFound(),
        );

    if (habit == null || habit.id.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final logs = ref
        .read(habitsProvider.notifier)
        .getLogsForHabit(habitId, lastDays: 30);
    final isCompletedToday =
        ref.read(habitsProvider.notifier).isCompletedToday(habitId);

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) async {
              if (v == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Remove habit?'),
                    content: const Text('This will archive the habit.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel')),
                      FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Remove')),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await ref.read(habitsProvider.notifier).deleteHabit(habit.id);
                  if (context.mounted) context.pop();
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'delete', child: Text('Remove Habit')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          _StatsRow(habit: habit),
          const SizedBox(height: AppSpacing.md),
          _ActivityHeatmap(logs: logs),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent logs', style: context.textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.sm),
                  if (logs.isEmpty)
                    Text(
                      'No logs yet',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceMuted,
                      ),
                    )
                  else
                    ...logs.take(10).map((l) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            l.loggedAt.relativeLabel,
                            style: context.textTheme.bodyMedium,
                          ),
                          trailing: l.note != null
                              ? Text(
                                  l.note!,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurfaceMuted,
                                  ),
                                )
                              : null,
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isCompletedToday
          ? null
          : FloatingActionButton.extended(
              onPressed: () =>
                  ref.read(habitsProvider.notifier).logCompletion(habitId),
              icon: const Icon(Icons.check),
              label: const Text("Done today"),
            ),
    );
  }

  Habit _notFound() => Habit(
        id: '',
        userId: '',
        title: 'Not found',
        createdAt: DateTime.now(),
      );
}

class _StatsRow extends StatelessWidget {
  final Habit habit;
  const _StatsRow({required this.habit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Current streak',
            value: '${habit.currentStreak}',
            suffix: ' days',
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            label: 'Best streak',
            value: '${habit.longestStreak}',
            suffix: ' days',
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String suffix;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceMuted,
                )),
            const SizedBox(height: AppSpacing.xs),
            RichText(
              text: TextSpan(
                text: value,
                style: context.textTheme.headlineMedium?.copyWith(color: color),
                children: [
                  TextSpan(
                    text: suffix,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityHeatmap extends StatelessWidget {
  final List<HabitLog> logs;
  const _ActivityHeatmap({required this.logs});

  @override
  Widget build(BuildContext context) {
    final logDays = logs.map((l) => DateTime(
          l.loggedAt.year,
          l.loggedAt.month,
          l.loggedAt.day,
        )).toSet();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last 30 days', style: context.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(30, (i) {
                final day = DateTime.now().subtract(Duration(days: 29 - i));
                final dayOnly = DateTime(day.year, day.month, day.day);
                final logged = logDays.contains(dayOnly);
                return Tooltip(
                  message: '${day.day}/${day.month}',
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: logged
                          ? AppColors.success
                          : AppColors.onSurfaceMuted.withValues(alpha: 0.15),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

extension on DateTime {
  String get relativeLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);
    final diff = today.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$day/$month/$year';
  }
}
