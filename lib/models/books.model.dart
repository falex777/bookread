// repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// import 'package:http/http.dart' as http;
final input =
    '[{"code": 1343, "title": "1984", "author": "Джордж Оруэлл", "img": "1.jpg", "booktxt": "Главный герой — Уинстон Смит — живёт в Лондоне, работает в министерстве правды и является членом внешней партии. Он не разделяет партийные лозунги и идеологию и в глубине души сильно сомневается в партии, в окружающей действительности и вообще во всём том, в чём только можно сомневаться. Чтобы «выпустить пар» и не сделать безрассудный поступок, он покупает дневник, в котором старается излагать все свои сомнения. На людях же он старается притворяться приверженцем партийных идей. Однако он опасается, что девушка Джулия, работающая в том же министерстве, шпионит за ним и хочет разоблачить его. В то же время он полагает, что высокопоставленный сотрудник их министерства, член внутренней партии (некий О’Брайен) также не разделяет мнения партии и является подпольным революционером. Однажды оказавшись в районе пролов, где члену партии появляться нежелательно, он заходит в лавку старьёвщика Чаррингтона. Тот показывает ему комнату наверху, и Уинстон мечтает пожить там хотя бы недельку. На обратном пути ему встречается Джулия. Уинстон понимает, что она следила за ним и приходит в ужас. Он колеблется между желанием убить её и страхом. Однако побеждает страх, и он не решается догнать и убить Джулию. Вскоре Джулия в министерстве передаёт ему записку, в которой она признаётся ему в любви. У них завязывается роман, они несколько раз в месяц устраивают свидания, но Уинстона не покидает мысль, что они уже покойники (свободные любовные отношения между мужчиной и женщиной запрещены партией). Они снимают комнатку у Чаррингтона, которая становится местом их регулярных встреч. Уинстон и Джулия решаются на безумный поступок и идут к О’Брайену и просят, чтобы он принял их в подпольное Братство, хотя сами лишь предполагают, что он в нём состоит. О’Брайен их принимает и даёт им книгу, написанную врагом государства Голдстейном. Через некоторое время их арестовывают в комнатке у мистера Чаррингтона, так как этот милый старик оказался сотрудником полиции. В министерстве любви Уинстона долго обрабатывают. Главным палачом, к удивлению Уинстона, оказывается О’Брайен. Сначала Уинстон пытается бороться и не отрекаться от себя. Однако от постоянных физических и психических мучений он постепенно отрекается от себя, от своих взглядов, надеясь отречься от них разумом, но не душой. Он отрекается от всего, кроме своей любви к Джулии. Однако и эту любовь ломает О’Брайен. Уинстон отрекается, предаёт её, думая, что он предал её на словах, разумом, от страха. Однако когда он уже «излечен» от революционных настроений и на свободе, сидя в кафе и попивая джин, он понимает, что в тот момент, когда отрёкся от неё разумом, он отрёкся от неё полностью. Он предал свою любовь. В это время по радио передают сообщение о победе войск Океании над армией Евразии, после чего Уинстон понимает, что теперь он полностью излечился.", "is_favorite": false},{"code": 22342, "title": "Убить пересмешника", "author": "Харпер Ли", "img": "2.jpg", "booktxt": "«Уби́ть пересме́шника» (англ. To Kill a Mockingbird) — роман-бестселлер американской писательницы Харпер Ли, опубликованный в 1960 году, за который в 1961 году она получила Пулитцеровскую премию. Её успех стал вехой в борьбе за права чернокожих.", "is_favorite": true},{"code": 3222, "title": "Гордость и предубеждение", "author": "Джейн Остин", "img": "3.jpg", "booktxt": "Роман начинается с беседы мистера и миссис Беннет о приезде молодого мистера Бингли в Незерфилд-парк. Жена уговаривает мужа навестить соседа и свести с ним более тесное знакомство. Она надеется, что мистеру Бингли непременно понравится одна из их пяти дочерей. Мистер Беннет наносит визит молодому человеку, и тот через какое-то время наносит ответный.", "is_favorite": false},{"code": 496754, "title": "Моби Дик", "author": "Herman Melville", "img": "4.jpg", "booktxt": "Повествование ведётся от имени американского моряка Измаила, ушедшего в рейс на китобойном судне «Пекод», капитан которого, Ахав (отсылка к библейскому Ахаву), одержим идеей мести гигантскому белому киту, убийце китобоев, известному как Моби Дик (в предыдущем плавании по вине кита Ахав потерял ногу, и с тех пор капитан использует протез).", "is_favorite": false},{"code": 5453, "title": "Великий Гэтсби", "author": "Фрэнсис Скотт Фицджеральд", "img": "2.jpg", "booktxt": "Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками", "is_favorite": false},{"code": 63578, "title": "Преступление и наказание", "author": "Фёдор Достоевский", "img": "1.jpg", "booktxt": "Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками", "is_favorite": false}]';

class BooksStore extends ChangeNotifier {
  final List<BookItem> _books = [];
  final baseUrl = "http://localhost:8080/";

  UserProfile _userProfile = UserProfile();

  List<BookItem> get list => _books;
  UserProfile get userProfile => _userProfile;

  int maxCode() {
    int maxCode = _books[0].code;
    for (int i = 1; i < _books.length; i++) {
      if (_books[i].code > maxCode) {
        maxCode = _books[i].code;
      }
    }
    return maxCode;
  }

  // List<BookItem> get favorites => _books.where((book) => book.isFavorite).toList();
  int get length => _books.length;

  List<BookItem> favorites() {
    return _books.where((book) => book.isFavorite).toList();
  }

  Future<void> fetchBooks() async {
    _books.clear();
    try {
      // var input = await File('_bookslib.json').readAsString();
      List jsonResponse = jsonDecode(input);
      List books = jsonResponse.map((book) => BookItem.fromJson(book)).toList();
      _books.addAll(books as List<BookItem>);
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> playAudio(String txt) async {
    final player = AudioPlayer();
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}getaudio'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'text': txt}),
      );

      if ((response.statusCode / 100 ).round() == 2) {
        List jsonResponse = json.decode(response.body);
        player.play(UrlSource(baseUrl + jsonResponse.toList()[0]));
      } else {
        player.play(AssetSource('demo.mp3'));
      }
    } catch (e) {
      player.play(AssetSource('demo.mp3'));
    }
    
    notifyListeners();
  }

  Future<void> addBook(BookItem newBook) async {
    /* final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newBook.toJson()),
    ); 

    if (response.statusCode != 201) {
      throw Exception('Failed add new book');
    }
    */
    _books.insert(0, newBook);
    notifyListeners();
  }

  Future<void> updateBook(BookItem updBook) async {
    /* final response = await http.put(
      Uri.parse('$baseUrl/${upd_book.code}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(upd_book.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update book');
    } */

    int index = _books.indexWhere((item) => item.code == updBook.code);
    if (index > -1) _books[index] = updBook;
    notifyListeners();
  }

  Future<void> deleteBook(int code) async {
    /* final response = await http.delete(Uri.parse('$baseUrl/$code'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete book');
    }*/
    _books.removeWhere((item) => item.code == code);
    notifyListeners();
  }

  Future<void> toggleFavorite(int code) async {
    /* final response = await http.post(Uri.parse('$baseUrl/setfavorite/$code'));
    if (response.statusCode != 204) {
      throw Exception('Failed set favotite book');
    } */
    int index = _books.indexWhere((item) => item.code == code);
    if (index != -1) _books[index].isFavorite = !_books[index].isFavorite;
    notifyListeners();
  }

  Future<void> updateProfile(UserProfile profile) async {
    _userProfile = profile;
    notifyListeners();
  }
}

class BookItem {
  final int code;
  final String title;
  final String author;
  final String booktxt;
  final String img;
  bool isFavorite;

  BookItem({
    required this.code,
    required this.title,
    required this.author,
    this.booktxt = '',
    this.img = '',
    this.isFavorite = false,
  });

  factory BookItem.fromJson(Map<String, dynamic> json) {
    return BookItem(
      code: json['code'],
      title: json['title'],
      author: json['author'],
      booktxt: json['booktxt'],
      img: json['img'],
      isFavorite: json['is_favorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'author': author,
      'booktxt': booktxt,
      'img': img,
      'is_favorite': isFavorite,
    };
  }

  void toggleFavorite(int index) {
    // booksStore[index].isFavorite = !booksStore[index].isFavorite;
  }
}

class UserProfile {
  int uid;
  String name;
  String surname;
  String email;

  UserProfile({
    this.uid = 0,
    this.name = '',
    this.surname = '',
    this.email = '',
  });
}
