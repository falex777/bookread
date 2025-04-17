import 'package:flutter/material.dart';
import 'package:books_reader/models/books.model.dart';

class BookCard extends StatelessWidget {
  final BookItem book;
  final VoidCallback onAction;
  final VoidCallback onTap;

  const BookCard({
    super.key,
    required this.book,
    required this.onAction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: ListTile(
        leading: GestureDetector(
          child: Hero(
            tag: 'bookImage${book.id}',
            child: Image.asset(
              'assets/img/${book.img}',
              width: 50,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.book, size: 50);
              },
            ),
          ),
        ),
        title: Text(book.title, style: theme.textTheme.titleLarge),
        subtitle: Text(book.author, style: theme.textTheme.bodySmall),
        trailing: IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: onAction,
        ),
        onTap: onTap,
      ),
    );
  }
} 