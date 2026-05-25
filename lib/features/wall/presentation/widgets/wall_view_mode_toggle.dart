import 'package:read_radius/features/wall/providers/wall_providers.dart';
import 'package:flutter/material.dart';

class WallViewModeToggle extends StatelessWidget {
  const WallViewModeToggle({
    required this.mode,
    required this.onModeSelected,
    super.key,
  });

  final WallBooksViewMode mode;
  final ValueChanged<WallBooksViewMode> onModeSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SegmentedButton<WallBooksViewMode>(
        segments: const <ButtonSegment<WallBooksViewMode>>[
          ButtonSegment<WallBooksViewMode>(
            value: WallBooksViewMode.grid,
            icon: Icon(Icons.grid_view_rounded),
            label: Text('Grid'),
          ),
          ButtonSegment<WallBooksViewMode>(
            value: WallBooksViewMode.list,
            icon: Icon(Icons.view_list_rounded),
            label: Text('List'),
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
