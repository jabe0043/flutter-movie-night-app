import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:movie_night_app/provider/movie_session_provider.dart';
import 'package:movie_night_app/data/models/session_api_model.dart';

//change to include model as a param (host, join, vote, tmdb)
class HttpHelper {
  Future<dynamic> fetch(String url) async {
    print("3. Http helper -- fetching url: $url");
    Uri uri = Uri.parse(url);
    http.Response res = await http.get(uri);
    if (res.statusCode == 200) {
      // I need to add condition to decode the json in the tmdb format.
      Map<String, dynamic> data = jsonDecode(res.body);
      print("4. Http helper -- data retrieved: $data");
      return data;
    } else {
      print("Http helper -- error");
      throw Exception('Failed to get response.');
    }
  }
}
