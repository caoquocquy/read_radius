import 'package:flutter/material.dart';
import 'package:read_radius/features/book_details/presentation/widgets/book_cover.dart';

class BookDetailsHeader extends StatelessWidget {
  const BookDetailsHeader({
    required this.thumbnailUrl,
    required this.title,
    required this.authors,
    super.key,
  });

  final String? thumbnailUrl;
  final String title;
  final List<String> authors;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BookCover(url: thumbnailUrl),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                authors.isEmpty ? 'Unknown author' : authors.join(', '),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
