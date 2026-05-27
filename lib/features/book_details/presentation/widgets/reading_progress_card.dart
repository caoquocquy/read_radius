import 'package:flutter/material.dart';

class ReadingProgressCard extends StatelessWidget {
  const ReadingProgressCard({
    required this.displayedPercent,
    required this.isBusy,
    required this.onUpdateProgress,
    super.key,
  });

  final int displayedPercent;
  final bool isBusy;
  final VoidCallback onUpdateProgress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Reading Progress',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: displayedPercent / 100,
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$displayedPercent%',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (isBusy)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isBusy ? null : onUpdateProgress,
                icon: const Icon(Icons.tune_rounded),
                label: const Text('Update Progress'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
