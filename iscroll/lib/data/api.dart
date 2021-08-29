import 'dart:convert';
import 'package:iscroll/model/lecture.dart';
import 'package:http/http.dart' as http;

class MovieRepository {
  Future<Playing> getNowPlaying(int currentPage) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=b64508afff2418ed0dcf89b770586d77&language=en-EN&page=' +
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
