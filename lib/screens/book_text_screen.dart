import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:books_reader/models/books.model.dart';

class BookTextScreen extends StatefulWidget {
  const BookTextScreen({super.key});

  @override
  State<BookTextScreen> createState() => _BookTextScreenState();
}

class _BookTextScreenState extends State<BookTextScreen> {
  int index = 0;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  double _fontSize = 16.0;
  Color _backgroundColor = Color(0xFFF5F1E4); // Бежевый цвет фона из макета

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    super.didChangeDependencies();
    assert(args != null && args is int, 'Error: arguments must be int');
    index = args as int;
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  Widget _buildTitle(String title) {
    return _isSearching
        ? TextField(
            controller: _searchController,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'Поиск...',
              hintStyle: TextStyle(color: Colors.black54),
              border: InputBorder.none,
            ),
            autofocus: true,
          )
        : Text(title, style: TextStyle(color: Colors.black87));
  }

  void _showTextSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Настройки текста',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Размер шрифта'),
                Expanded(
                  child: Slider(
                    value: _fontSize,
                    min: 12,
                    max: 24,
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showVoiceSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Настройки озвучки',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Скорость речи'),
              trailing: DropdownButton<String>(
                value: 'Нормальная',
                items: ['Медленная', 'Нормальная', 'Быстрая']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final booksStore = Provider.of<BooksStore>(context);
    final book = booksStore.list[index];

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: _buildTitle(book.title),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, 
                      color: Colors.black87),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: Icon(Icons.text_fields, color: Colors.black87),
            onPressed: _showTextSettings,
          ),
          IconButton(
            icon: Icon(Icons.settings_voice, color: Colors.black87),
            onPressed: _showVoiceSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Text(
          book.booktxt,
          style: TextStyle(
            fontSize: _fontSize,
            color: Colors.black87,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
} 