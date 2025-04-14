import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:books_reader/models/books.model.dart';

class BooksList extends StatefulWidget {
  const BooksList({super.key, required this.title});
  final String title;

  @override
  State<BooksList> createState() => _BooksList();
}

class _BooksList extends State<BooksList> {
  // final bookStore = Provider.of<BooksStore>(context);
  // final bookStore = Provider.of<BooksStore>(context, listen: false);

  @override
  void initState() {
    super.initState();
    // Вызов метода для загрузки книг
    Future.microtask(
        () => Provider.of<BooksStore>(context, listen: false).fetchBooks());
  }

  // Функция для удаления книги
  void _deleteBook(bookStore, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: const Text('Вы уверены, что хотите удалить эту книгу?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                setState(() {
                  bookStore.deleteBook(bookStore.list[index].code);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addBook(bookStore) {
    final code = bookStore.maxCode() + 1;
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final priceController = TextEditingController();
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
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Добавить'),
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    authorController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    imgController.text.isNotEmpty) {
                  try {
                    final newBook = BookItem(
                      code: code,
                      title: titleController.text,
                      author: authorController.text,
                      booktxt: bookTxtController.text,
                      img: imgController.text,
                    );
                    await bookStore.addBook(newBook);
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Ошибка')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Ошибка: все поля должны быть заполнены.')),
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
    // final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _addBook(bookStore),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: bookStore.length,
        separatorBuilder: (context, index) =>
            const Divider(color: Colors.green),
        itemBuilder: (context, index) => ListTile(
          leading: Image.asset(
            'assets/img/${bookStore.list[index].img}',
            width: 50,
            height: 50,
          ),
          title: Text(bookStore.list[index].title,
            style: TextStyle(color: Colors.black87)
          ),
          subtitle: Text(bookStore.list[index].author,
            style: TextStyle(color: Colors.green[400])
          ),
          trailing: Wrap(
            children: [              
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(
                    bookStore.list[index].isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: bookStore.list[index].isFavorite
                        ? Colors.red
                        : Colors.green[200]),
                onPressed: () {
                  bookStore.toggleFavorite(bookStore.list[index].code);
                },
              ),              
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(Icons.delete, color: Colors.green[200]),
                onPressed: () => _deleteBook(bookStore, index),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).pushNamed('/info', arguments: index);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(        
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Книги'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Избранное'),
          BottomNavigationBarItem(icon: Icon(Icons.filter_alt), label: 'Фильтр'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.green[500],
        unselectedItemColor: Colors.green[500],
        backgroundColor: Colors.green[500],
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigator.of(context).pushNamed('/');
              bookStore.fetchBooks();
              break;
            case 1:
              Navigator.of(context).pushNamed('/favorites');
              break;
            case 2:
              
              break;
            case 3:
              Navigator.of(context).pushNamed('/profile');
              break;
          }
        },
      ),
    );
  }
}
