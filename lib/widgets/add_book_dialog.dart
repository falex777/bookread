import 'package:flutter/material.dart';
import 'package:read_aloud_front/models/books.model.dart';

class AddBookDialog extends StatefulWidget {
  final void Function(BookItem) onAdd;
  final int newId;
  const AddBookDialog({super.key, required this.onAdd, required this.newId});

  @override
  State<AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<AddBookDialog> {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final bookTxtController = TextEditingController();
  final imgController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    bookTxtController.dispose();
    imgController.dispose();
    super.dispose();
  }

  void _submit() {
    if (titleController.text.isNotEmpty &&
        authorController.text.isNotEmpty &&
        imgController.text.isNotEmpty) {
      final newBook = BookItem(
        id: widget.newId,
        title: titleController.text,
        author: authorController.text,
        booktxt: bookTxtController.text,
        img: imgController.text,
      );
      widget.onAdd(newBook);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка: все поля должны быть заполнены.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: const InputDecoration(labelText: 'Изображение (имя файла)'),
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
          onPressed: _submit,
        ),
      ],
    );
  }
} 