import 'package:flutter/material.dart';

class BookPreviewButton extends StatelessWidget {
  const BookPreviewButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.open_in_new_rounded),
      label: const Text('Open Google Books Preview'),
    );
  }
}
