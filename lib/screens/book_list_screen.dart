import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:books_reader/models/books.model.dart';
import 'package:books_reader/widgets/book_card.dart';
import 'package:books_reader/widgets/book_card_grid.dart';
import 'package:books_reader/widgets/book_action_sheet.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key, required this.title});
  final String title;

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final _searchController = TextEditingController();
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<BooksStore>(context, listen: false).fetchBooks());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showBookActions(BuildContext context, BooksStore bookStore, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BookActionSheet(
          book: bookStore.list[index],
          onShare: () {
            // Implement share functionality
            Navigator.pop(context);
          },
          onEdit: () {
            Navigator.pop(context);
            _editBook(bookStore, index);
          },
          onDelete: () {
            Navigator.pop(context);
            _deleteBook(bookStore, index);
          },
        );
      },
    );
  }

  // Функция для копирования файла в локальное хранилище приложения
  Future<String> _copyFileToAppStorage(File sourceFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(sourceFile.path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueFileName = '${timestamp}_$fileName';
      final targetPath = path.join(appDir.path, 'books', uniqueFileName);
      
      // Создаем директорию, если она не существует
      final targetDir = Directory(path.dirname(targetPath));
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }
      
      // Копируем файл
      final newFile = await sourceFile.copy(targetPath);
      return newFile.path;
    } catch (e) {
      print('Ошибка при копировании файла: $e');
      return '';
    }
  }
  
  // Функция для выбора файла книги
  Future<String> _pickBookFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'epub', 'pdf', 'fb2'],
      );
      
      if (result != null && result.files.single.path != null) {
        // Возвращаем только путь к выбранному файлу, без копирования
        return result.files.single.path!;
      }
    } catch (e) {
      print('Ошибка при выборе файла: $e');
    }
    return '';
  }

  void _editBook(BooksStore bookStore, int index) {
    final book = bookStore.list[index];
    final titleController = TextEditingController(text: book.title);
    final authorController = TextEditingController(text: book.author);
    final bookTxtController = TextEditingController(text: book.booktxt);
    final imgController = TextEditingController(text: book.img);
    String bookFilePath = book.bookFilePath;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Редактировать книгу'),
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        bookFilePath.isEmpty 
                            ? 'Файл книги не выбран' 
                            : 'Файл: ${path.basename(bookFilePath)}',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final filePath = await _pickBookFile();
                        if (filePath.isNotEmpty) {
                          setState(() {
                            bookFilePath = filePath;
                          });
                        }
                      },
                      child: const Text('Выбрать файл'),
                    ),
                  ],
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
              child: const Text('Сохранить'),
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    authorController.text.isNotEmpty &&
                    imgController.text.isNotEmpty) {
                  try {
                    // Копируем файл в хранилище приложения, если был выбран новый файл
                    String finalBookFilePath = book.bookFilePath;
                    if (bookFilePath.isNotEmpty && bookFilePath != book.bookFilePath) {
                      finalBookFilePath = await _copyFileToAppStorage(File(bookFilePath));
                    }
                    
                    final updatedBook = BookItem(
                      id: book.id,
                      title: titleController.text,
                      author: authorController.text,
                      booktxt: bookTxtController.text,
                      img: imgController.text,
                      bookFilePath: finalBookFilePath,
                      progress: book.progress,
                      isFavorite: book.isFavorite,
                    );
                    await bookStore.updateBook(updatedBook);
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ошибка при сохранении')),
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
    String bookFilePath = '';

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
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        /* bookFilePath.isEmpty 
                            ? 'Файл книги не выбран' 
                            :  */'Файл: ${path.basename(bookFilePath)}',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final filePath = await _pickBookFile();
                        if (filePath.isNotEmpty) {
                          setState(() {
                            bookFilePath = filePath;
                          });
                        }
                      },
                      child: const Text('Выбрать файл'),
                    ),
                  ],
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
                    // Копируем файл в хранилище приложения только при нажатии кнопки Добавить
                    String finalBookFilePath = '';
                    if (bookFilePath.isNotEmpty) {
                      finalBookFilePath = await _copyFileToAppStorage(File(bookFilePath));
                    }
                    
                    final newBook = BookItem(
                      id: id,
                      title: titleController.text,
                      author: authorController.text,
                      booktxt: bookTxtController.text,
                      img: imgController.text,
                      bookFilePath: finalBookFilePath,
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Поиск',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          prefixIcon: Icon(Icons.search, color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.filter_alt_outlined),
                      onPressed: () {},
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                      onPressed: () {
                        setState(() {
                          _isGridView = !_isGridView;
                        });
                      },
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: _isGridView
                    ? GridView.builder(
                        padding: EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: bookStore.length,
                        itemBuilder: (context, index) => BookCardGrid(
                          book: bookStore.list[index],
                          onAction: () => _showBookActions(context, bookStore, index),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/info', arguments: index);
                          },
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.only(top: 16),
                        itemCount: bookStore.length,
                        separatorBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(height: 1, color: Colors.black12),
                        ),
                        itemBuilder: (context, index) => BookCard(
                          book: bookStore.list[index],
                          onAction: () => _showBookActions(context, bookStore, index),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/info', arguments: index);
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: () => _addBook(bookStore),
          backgroundColor: Colors.white,
          elevation: 2,
          shape: CircleBorder(
            side: BorderSide(
              width: 2,
              color: Colors.black54,
            ),
          ),
          child: Icon(Icons.add, color: Colors.black54, size: 32),
        ),
      ),
    );
  }
}