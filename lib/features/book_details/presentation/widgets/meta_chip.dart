import 'package:flutter/material.dart';

class MetaChip extends StatelessWidget {
  const MetaChip({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}
