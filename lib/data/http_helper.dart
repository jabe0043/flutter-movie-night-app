import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:movie_night_app/provider/movie_session_provider.dart';
import 'package:movie_night_app/data/models/session_api_model.dart';

enum API {
  server,
  tmdb,
}

//change to include model as a param (host, join, vote, tmdb)
class HttpHelper {
  Future<dynamic> fetch(String url) async {
    Uri uri = Uri.parse(url);
    http.Response res = await http.get(uri);
    if (res.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(res.body) as Map<String, dynamic>;
      return data;
    } else {
      throw Exception('Failed to get response.');
    }
  }
}
