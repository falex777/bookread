import 'package:flutter/material.dart';
import 'package:books_reader/theme.dart';
import 'package:provider/provider.dart';
import 'package:books_reader/booklist.dart';
import 'package:books_reader/models/books.model.dart'; 
import 'package:books_reader/bookinfo.dart';
import 'package:books_reader/favorite.dart'; 
import 'package:books_reader/profile.dart'; 


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BooksStore(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Читалка вслух',
        theme: DarkTheme,
        routes: {
          '/': (context) => BooksList(title: 'Каталог книг'),
          '/info': (context) => BookInfo(title: 'Читалка'),
          '/favorites': (context) => const FavoritesPage(), 
          '/profile': (context) => ProfilePage(),
        },
      )
    );
  }
}
