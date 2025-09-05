import 'package:flutter/material.dart';
import 'quote.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback delete;
  final VoidCallback like;

  const QuoteCard({super.key, required this.quote, required this.delete, required this.like});

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'inspiration':
        return Colors.lightBlue[100]!;
      case 'humor':
        return Colors.yellow[100]!;
      case 'wisdom':
        return Colors.green[100]!;
      default:
        return Colors.grey[300]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      color: _getCategoryColor(quote.category),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              quote.text,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              '- ${quote.author}',
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(quote.category),
              backgroundColor: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${quote.likes}'),
                IconButton(
                  icon: const Text('👍', style: TextStyle(fontSize: 20)),
                  onPressed: like,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: delete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
