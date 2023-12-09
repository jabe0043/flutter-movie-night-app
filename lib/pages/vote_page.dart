import 'package:flutter/material.dart';
import 'package:movie_night_app/provider/movie_session_provider.dart';
import 'package:provider/provider.dart';
import 'package:movie_night_app/data/models/movie_model.dart';
import 'package:movie_night_app/data/http_helper.dart';

class VotePage extends StatefulWidget {
  const VotePage({Key? key}) : super(key: key);

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  final String _apiKey = "9fc4a27f2f15369e443ecea3e67ea415";
  final String baseUrl =
      "https://api.themoviedb.org/3/movie/now_playing?language=en-US";
  int page = 1;
  late Future<List<Movie>> _movies; //20 movies in current rotation
  List<Movie> votedMovies = []; //movies that have been voted on
  int _currentIndex = 0;

  String url(page) => "$baseUrl&api_key=$_apiKey&page=$page";
  String imagePath(path) => 'https://image.tmdb.org/t/p/w500/$path';
  Map<String, dynamic>? voteInfo;

  @override
  void initState() {
    super.initState();
    _movies = fetchData(url(page));
  }

  Future<List<Movie>> fetchData(String url) async {
    try {
      final res = await HttpHelper().fetch(url);
      List<Movie> movies = res['results'].map<Movie>((movie) {
        return Movie.fromJson(movie);
      }).toList();
      setState(() {
        _movies = Future.value(movies);
        page++;
      });
      return movies;
    } catch (e) {
      print("Error fetching data: $e"); //TODO: show toast
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieSessionProvider>(
      builder: (context, movieSessionProvider, child) => Scaffold(
        appBar: AppBar(
          title: const Text('ReelSync'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder<List<Movie>>(
              future: _movies,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
                if (snapshot.hasData) {
                  return _movieCard(
                      movieSessionProvider, snapshot.data![_currentIndex]);
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _movieCard(MovieSessionProvider movieSessionProvider, Movie movie) {
    var movieImage = imagePath(movie.posterPath);

    _handleSwipe(Movie movie, bool vote) {
      setState(() {
        voteInfo = {"movieId": movie.id, "vote": vote};
        print(voteInfo);
        if (vote) {
          print("VOTED YES -- ${movie.title}");
        } else {
          print("VOTED NO -- ${movie.title}");
        }
        movieSessionProvider.setMovieNightUrl(
            SessionType.vote, null, movie.id, vote);
        votedMovies.add(movie);
        print("voted on a total of: ${votedMovies.length}");
        _currentIndex++;
        if (_currentIndex % 20 == 0) {
          _currentIndex = 0;
          fetchData(url(page));
        }
      });
    }

    return Dismissible(
      key: ValueKey<int>(movie.id),
      onDismissed: (DismissDirection direction) {
        print("${movie.title} was voted: $direction");
        _handleSwipe(movie, direction == DismissDirection.endToStart);
      },
      child: Card(
        elevation: 40,
        clipBehavior: Clip.hardEdge,
        child: SingleChildScrollView(
          child: Stack(
            //TODO:?? make bg img
            children: [
              Image.network(imagePath(movieImage)),
              Text(movie.title),
            ],
          ),
        ),
      ),
    );
  }
}
