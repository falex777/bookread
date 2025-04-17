import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

final input =
    '[{"id": 1, "title": "Метро 2033", "author": "Дмитрий Глуховский", "img": "1.jpg", "booktxt": "Книга повествует о людях, оставшихся в живых после ядерной войны. В романе война упоминается лишь вскользь. В результате обмена ядерными ударами все крупные города были стёрты с лица земли. Почти всё действие разворачивается в Московском метрополитене, где на станциях и в переходах живут люди. Благодаря оперативным действиям служб гражданской обороны метрополитен удалось оградить от радиации: почти на всех станциях были закрыты гермозатворы, а в системах вентиляции и водоснабжения активированы противорадиационные фильтры. При этом лишь менее половины станций обитаемы: часть станций заброшена, часть изолирована обрушением тоннелей, часть сгорела. Некоторые станции захвачены существами с поверхности. Живущие в метро питаются тем, что смогли вырастить в тоннелях."},{"id": 2, "title": "Дао Toyota", "author": "Джеффри Лайкер", "img": "2.jpg", "booktxt": "«Джеффри Лайкер переосмыслил и обновил свой бестселлер, ставший одной из самых влиятельных бизнес-книг XXI века. Руководство по легендарной философии и производственной системе Toyota теперь дополнено внушительной базой для стимулирования инноваций в бизнесе. Второе издание полностью пересматривает подход Toyota к конкурентоспособности в нашем мире мобильности и интеллектуальных технологий. Не менее важен и новый подход к моделям лидерства и анализ принципа «ката» ― формирования у людей привычки к научному мышлению на основе практики и обратной связи. Научное мышление автор теперь ставит в центр решения проблем, меняя видение идеи бережливой трансформации на более гибкое и динамичное."},{"id": 3, "title": "Бойцовский клуб", "author": "Чак Паланик", "img": "3.jpg", "booktxt": "Главный герой работает консультантом по страховым выплатам в компании, занимающейся производством автомобилей. Из-за своей работы он постоянно путешествует по стране. В поездках героя окружают одноразовые вещи и одноразовые люди, целый одноразовый мир. Герой мучится бессонницей, из-за которой уже с трудом откликается на реальность. Несмотря на мучения Рассказчика, доктор не прописывает ему снотворное, а советует просто отдохнуть и посещать группу поддержки для неизлечимо больных, чтобы увидеть, как выглядит настоящее страдание. Главный герой находит, что посещение множества самых разных групп поддержки улучшает его состояние, несмотря на то, что он не является неизлечимо больным."}]';

class BooksStore extends ChangeNotifier {
  final List<BookItem> _books = [];
  final baseUrl = "http://localhost:8080/";
  UserProfile _userProfile = UserProfile();

  List<BookItem> get list => _books;
  UserProfile get userProfile => _userProfile;

  int maxCode() {
    if (_books.isEmpty) return 0;
    int maxCode = _books[0].id;
    for (int i = 1; i < _books.length; i++) {
      if (_books[i].id > maxCode) {
        maxCode = _books[i].id;
      }
    }
    return maxCode;
  }

  int get length => _books.length;

  Future<void> fetchBooks() async {
    _books.clear();
    try {
      List jsonResponse = jsonDecode(input);
      List<BookItem> books =
          jsonResponse.map((book) => BookItem.fromJson(book)).toList();
      _books.addAll(books);
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          await player.play(UrlSource(baseUrl + jsonResponse[0]));
        } else {
          await player.play(AssetSource('demo.mp3'));
        }
      } else {
        await player.play(AssetSource('demo.mp3'));
      }
    } catch (e) {
      await player.play(AssetSource('demo.mp3'));
    }

    notifyListeners();
  }

  Future<void> addBook(BookItem newBook) async {
    _books.insert(0, newBook);
    notifyListeners();
  }

  Future<void> updateBook(BookItem updBook) async {
    int index = _books.indexWhere((item) => item.id == updBook.id);
    if (index != -1) {
      _books[index] = updBook;
      notifyListeners();
    }
  }

  Future<void> deleteBook(int id) async {
    _books.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<void> updateProfile(UserProfile profile) async {
    _userProfile = profile;
    notifyListeners();
  }
}

class BookItem {
  final int id;
  final String title;
  final String author;
  final String booktxt;
  final String img;
  bool isFavorite;

  BookItem({
    required this.id,
    required this.title,
    required this.author,
    this.booktxt = '',
    this.img = '',
    this.isFavorite = false,
  });

  factory BookItem.fromJson(Map<String, dynamic> json) {
    return BookItem(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      booktxt: json['booktxt'] as String? ?? '',
      img: json['img'] as String? ?? '',
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'booktxt': booktxt,
      'img': img,
      'is_favorite': isFavorite,
    };
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
