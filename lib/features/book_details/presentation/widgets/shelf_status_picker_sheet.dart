import 'package:flutter/material.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';

class ShelfStatusPickerSheet extends StatelessWidget {
  const ShelfStatusPickerSheet({required this.currentStatus, super.key});

  final ShelfStatus? currentStatus;

  Future<ShelfStatus?> show(BuildContext context) {
    return showModalBottomSheet<ShelfStatus>(
      context: context,
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ShelfStatus.values
            .map((ShelfStatus status) {
              final bool isSelected = status == currentStatus;
              return ListTile(
                leading: isSelected
                    ? const Icon(Icons.check_rounded)
                    : const SizedBox(width: 24),
                title: Text(status.actionLabel),
                onTap: () {
                  Navigator.of(context).pop(status);
                },
              );
            })
            .toList(growable: false),
      ),
    );
  }
}
