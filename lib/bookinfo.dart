import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:books_reader/models/books.model.dart';

// import 'package:my_first_app/repository.dart';

class BookInfo extends StatefulWidget {
  const BookInfo({super.key, required this.title});
  final String title;

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  int index = 0;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    super.didChangeDependencies();
    assert(args != null && args is int, 'Error: arguments must be int');
    index = args as int;
  }

  void _deleteBook(BookItem book) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Подтверждение удаления'),
          content: Text('Вы уверены, что хотите удалить "${book.title}"?'),
          actions: [
            TextButton(
              onPressed: () async {                
                final booksStore = Provider.of<BooksStore>(context);
                booksStore.deleteBook(book.code);
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Возврат на предыдущий экран
              },
              child: Text('Удалить'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final booksStore = Provider.of<BooksStore>(context);
    final book = booksStore.list[index];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(book.isFavorite == true
                ? Icons.favorite
                : Icons.favorite_border),
            color: book.isFavorite ? Colors.red : Colors.grey,
            onPressed: () {
              booksStore.toggleFavorite(book.code);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(!book.isFavorite ? 'Книга добавлена в избранное' : 'Книга удалена из избранного'),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white70),
            onPressed: () => _deleteBook(book),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/img/${book.img}',
              width: 200,
              height: 200,
              scale: .5,
            ),
            Container(
              padding: EdgeInsets.only(top: 30),
              child: Text(book.author,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Text(book.title,
                style: theme.textTheme.labelLarge,
                textAlign: TextAlign.center
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Text(book.booktxt,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ), 
                textAlign: TextAlign.justify
              ),
            )
          ],
        ),
        )
      ),      
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: 'Воспроизвести'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Оглавление'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[300],
        backgroundColor: Colors.green[500],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              break;
          }
        },
      ),
    );
  }
}
