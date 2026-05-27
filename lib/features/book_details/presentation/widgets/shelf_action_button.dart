import 'package:flutter/material.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';

class ShelfActionButton extends StatelessWidget {
  const ShelfActionButton({
    required this.currentStatus,
    required this.isBusy,
    required this.isDisabled,
    required this.onPressed,
    super.key,
  });

  final ShelfStatus? currentStatus;
  final bool isBusy;
  final bool isDisabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: isBusy || isDisabled ? null : onPressed,
      icon: isBusy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.collections_bookmark_outlined),
      label: Text(currentStatus?.actionLabel ?? 'Want to Read'),
    );
  }
}
