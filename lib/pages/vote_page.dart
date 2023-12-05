import 'package:flutter/material.dart';
import 'package:movie_night_app/pages/join_session_page.dart';
import 'package:movie_night_app/provider/movie_session_provider.dart';
import 'package:provider/provider.dart';
import 'package:movie_night_app/data/models/movie_model.dart';
import 'package:movie_night_app/data/http_helper.dart';

class VotePage extends StatefulWidget {
  const VotePage({Key? key}) : super(key: key);

  @override
  State<VotePage> createState() => _VotePage();
}

// image path: https://image.tmdb.org/t/p/w500/wwemzKWzjKYJFfCeiB57q3r4Bcm.png
class _VotePage extends State<VotePage> {
  final String _apiKey = "9fc4a27f2f15369e443ecea3e67ea415";
  final String baseUrl =
      "https://api.themoviedb.org/3/movie/now_playing?language=en-US";
  int page = 1;
  late String url = '$baseUrl&api_key=$_apiKey&page=$page';

  List<Movie> movies = [];

  String imagePath(path) => 'https://image.tmdb.org/t/p/w500/$path';

  @override
  void initState() {
    //equivalent to the react useEffect hook. When the app loads, go fetch data.
    super.initState();
    fetchData(); // Call the method to fetch data
  }

  Future<void> fetchData() async {
    try {
      await HttpHelper().fetch(url).then((res) {
        setState(() {
          movies = res['results'].map<Movie>((movie) {
            return Movie.fromJson(movie);
          }).toList();
        });
        print("movies array length: ${movies.length}");
      });
    } catch (e) {
      print("Error - $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieSessionProvider>(
      builder: (context, movieSessionProvider, child) => Scaffold(
        appBar: AppBar(
          title: const Text('ReelSync'),
        ),
        body: Column(
          children: [
            const Text("Movies Page"),
            Text("${movieSessionProvider.deviceId}")
          ],
        ),
      ),
    );
  }
}
