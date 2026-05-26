import 'package:read_radius/features/home/providers/home_providers.dart';
import 'package:flutter/material.dart';

class HomeViewModeToggle extends StatelessWidget {
  const HomeViewModeToggle({
    required this.mode,
    required this.onModeSelected,
    this.compact = false,
    super.key,
  });

  final HomeBooksViewMode mode;
  final ValueChanged<HomeBooksViewMode> onModeSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SegmentedButton<HomeBooksViewMode>(
        style: compact
            ? const ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 8),
                ),
              )
            : null,
        segments: <ButtonSegment<HomeBooksViewMode>>[
          ButtonSegment<HomeBooksViewMode>(
            value: HomeBooksViewMode.grid,
            icon: const Icon(Icons.grid_view_rounded),
            label: compact ? null : const Text('Grid'),
          ),
          ButtonSegment<HomeBooksViewMode>(
            value: HomeBooksViewMode.list,
            icon: const Icon(Icons.view_list_rounded),
            label: compact ? null : const Text('List'),
          ),
        ],
        selected: <HomeBooksViewMode>{mode},
        onSelectionChanged: (Set<HomeBooksViewMode> selection) {
          final HomeBooksViewMode? selected = selection.firstOrNull;
          if (selected != null) {
            onModeSelected(selected);
          }
        },
        showSelectedIcon: false,
      ),
    );
  }
}
