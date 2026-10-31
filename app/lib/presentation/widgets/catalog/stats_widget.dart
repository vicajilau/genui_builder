import 'package:flutter/material.dart';
import 'package:genui_gen/genui_gen.dart';
import '../../../l10n/app_localizations.dart';

part 'stats_widget.genui.dart';

/// A custom progress reporting widget showing completed vs total tasks
/// using a text summary label and a graphical linear progress indicator bar.
@GenUiWidget(
  description:
      'A custom progress reporting widget showing completed vs total tasks using a text summary label and a graphical linear progress indicator bar.',
)
class StatsWidget extends StatelessWidget {
  /// The total number of tasks.
  final int totalTasks;

  /// How many of the tasks are done.
  final int completedTasks;

  const StatsWidget({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.statsProgressStatus,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(l10n.statsCompletedCount(completedTasks, totalTasks)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
          ],
        ),
      ),
    );
  }
}
