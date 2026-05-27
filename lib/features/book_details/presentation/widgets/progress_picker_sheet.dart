import 'package:flutter/material.dart';

class ProgressPickerSheet extends StatelessWidget {
  const ProgressPickerSheet({required this.currentPercent, super.key});

  final int currentPercent;

  Future<int?> show(BuildContext context) {
    return showModalBottomSheet<int>(
      context: context,
      constraints: const BoxConstraints.expand(),
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Update Reading Progress',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Select your current percentage:'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final int value in <int>[20, 50, 70, 80, 90, 100])
                  SizedBox(
                    width: 76,
                    child: ChoiceChip(
                      label: Text('$value%'),
                      selected: currentPercent == value,
                      showCheckmark: false,
                      onSelected: (_) {
                        Navigator.of(context).pop(value);
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
