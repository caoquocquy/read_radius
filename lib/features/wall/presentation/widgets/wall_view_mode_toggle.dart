import 'package:read_radius/features/wall/providers/wall_providers.dart';
import 'package:flutter/material.dart';

class WallViewModeToggle extends StatelessWidget {
  const WallViewModeToggle({
    required this.mode,
    required this.onModeSelected,
    this.compact = false,
    super.key,
  });

  final WallBooksViewMode mode;
  final ValueChanged<WallBooksViewMode> onModeSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SegmentedButton<WallBooksViewMode>(
        style: compact
            ? const ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 8),
                ),
              )
            : null,
        segments: <ButtonSegment<WallBooksViewMode>>[
          ButtonSegment<WallBooksViewMode>(
            value: WallBooksViewMode.grid,
            icon: const Icon(Icons.grid_view_rounded),
            label: compact ? null : const Text('Grid'),
          ),
          ButtonSegment<WallBooksViewMode>(
            value: WallBooksViewMode.list,
            icon: const Icon(Icons.view_list_rounded),
            label: compact ? null : const Text('List'),
          ),
        ],
        selected: <WallBooksViewMode>{mode},
        onSelectionChanged: (Set<WallBooksViewMode> selection) {
          final WallBooksViewMode? selected = selection.firstOrNull;
          if (selected != null) {
            onModeSelected(selected);
          }
        },
        showSelectedIcon: false,
      ),
    );
  }
}
