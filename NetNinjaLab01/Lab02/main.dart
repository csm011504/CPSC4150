import 'package:flutter/material.dart';
import 'quote.dart';
import 'quote_card.dart';

void main() => runApp(MaterialApp(
  home: QuoteList(),
));

class QuoteList extends StatefulWidget {
  const QuoteList({super.key});

  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  List<Quote> quotes = [
    Quote(
        author: 'Oscar Wilde',
        text: 'Be yourself; everyone else is already taken',
        category: 'Inspiration'),
    Quote(
        author: 'Christopher Montague',
        text: 'I really want some Burger King right now',
        category: 'Humor'),
    Quote(
        author: 'Oscar Wilde',
        text: 'The truth is rarely pure and never simple',
        category: 'Wisdom'),
  ];

  void _addQuote(String author, String text, String category) {
    setState(() {
      quotes.add(Quote(author: author, text: text, category: category));
    });
  }

  void _deleteQuote(Quote quote) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quote'),
        content: const Text('Are you sure you want to delete this quote?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
            onPressed: () {
              setState(() {
                quotes.remove(quote);
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _likeQuote(Quote quote) {
    setState(() {
      quote.likes++;
    });
  }

  void _showAddQuoteDialog() {
    String author = '';
    String text = '';
    String category = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a New Quote'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Author'),
                onChanged: (value) {
                  author = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Quote'),
                onChanged: (value) {
                  text = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (value) {
                  category = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                if (author.isNotEmpty && text.isNotEmpty && category.isNotEmpty) {
                  _addQuote(author, text, category);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('These are Awesome Quotes'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: quotes.map((quote) =>
            QuoteCard(
              quote: quote,
              delete: () => _deleteQuote(quote),
              like: () => _likeQuote(quote),
            )).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddQuoteDialog,
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
