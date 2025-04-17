import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:books_reader/models/books.model.dart';
import 'package:books_reader/widgets/book_card.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key, required this.title});
  final String title;

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<BooksStore>(context, listen: false).fetchBooks());
  }


  void _actionBox(BooksStore bookStore, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Что делать с книгой?'),
          content: const Text('Всяко разно'),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteBook(BooksStore bookStore, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: const Text('Вы уверены, что хотите удалить эту книгу?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                setState(() {
                  bookStore.deleteBook(bookStore.list[index].id);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addBook(BooksStore bookStore) {
    final id = bookStore.maxCode() + 1;
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final bookTxtController = TextEditingController();
    final imgController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить книгу'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Название'),
                ),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(labelText: 'Автор'),
                ),
                TextField(
                  controller: bookTxtController,
                  decoration: const InputDecoration(labelText: 'Текст'),
                ),
                TextField(
                  controller: imgController,
                  decoration: const InputDecoration(
                      labelText: 'Изображение (имя файла)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Отмена'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Добавить'),
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    authorController.text.isNotEmpty &&
                    imgController.text.isNotEmpty) {
                  try {
                    final newBook = BookItem(
                      id: id,
                      title: titleController.text,
                      author: authorController.text,
                      booktxt: bookTxtController.text,
                      img: imgController.text,
                    );
                    await bookStore.addBook(newBook);
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ошибка')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Ошибка: все поля должны быть заполнены.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookStore = Provider.of<BooksStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _addBook(bookStore),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: bookStore.length,
        separatorBuilder: (context, index) => const Divider(color: Colors.green),
        itemBuilder: (context, index) => BookCard(
          book: bookStore.list[index],
          onAction: () => _deleteBook(bookStore, index),
          onTap: () {
            Navigator.of(context).pushNamed('/info', arguments: index);
          },
        ),
      ),
      floatingActionButton: Container(
        height: 50.0,
        width: 50.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            shape: CircleBorder(
              side: BorderSide(
                width: 4,
                color: Colors.black,
              ),
            ),
            elevation: 0,
            child: Icon(Icons.add, size: 48),
          ),
        ),
      ),      
    );
  }
} 