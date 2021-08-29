import 'dart:convert';
import 'package:iscroll/model/lecture.dart';
import 'package:http/http.dart' as http;

class MovieRepository {
  Future<Playing> getNowPlaying(int currentPage) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=5c6df9c99f2b050b7abd9320ed5d5878&language=en-EN&page=' +
            currentPage.toString());
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print('Get Data');
      return Playing.fromJson(json.decode(response.body));
    } else {
      throw Exception('Faild to load');
    }
  }
}
