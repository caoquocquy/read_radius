import 'package:flutter/material.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({required this.onWriteReview, super.key});

  final VoidCallback onWriteReview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Reviews', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const Text(
          'Reviews are coming soon. You can already add this book to your shelves.',
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onWriteReview,
          icon: const Icon(Icons.rate_review_outlined),
          label: const Text('Write Review'),
        ),
      ],
    );
  }
}
