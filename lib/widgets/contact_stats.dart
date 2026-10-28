import 'package:flutter/material.dart';

class ContactStats extends StatelessWidget {
  const ContactStats({
    super.key,
    required this.total,
    required this.favorite,
  });

  final int total;
  final int favorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng số liên hệ: $total',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Liên hệ yêu thích: $favorite',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}