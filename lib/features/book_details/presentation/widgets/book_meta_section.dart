import 'package:flutter/material.dart';
import 'package:read_radius/features/book_details/presentation/widgets/meta_chip.dart';
import 'package:read_radius/features/home/domain/home_book_details.dart';

class BookMetaSection extends StatelessWidget {
  const BookMetaSection({required this.details, super.key});

  final HomeBookDetails details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            if (details.publisher != null)
              MetaChip(label: 'Publisher', value: details.publisher!),
            if (details.publishedDate != null)
              MetaChip(label: 'Published', value: details.publishedDate!),
            if (details.pageCount != null)
              MetaChip(label: 'Pages', value: details.pageCount!.toString()),
          ],
        ),
        if (details.categories.isNotEmpty) ...<Widget>[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: details.categories
                .map((String category) => Chip(label: Text(category)))
                .toList(growable: false),
          ),
        ],
      ],
    );
  }
}
