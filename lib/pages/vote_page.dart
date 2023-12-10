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

    handleSwipe(Movie movie, bool vote) async {
      await movieSessionProvider.setMovieNightUrl(
          SessionType.vote, null, movie.id, vote);
      var voteResult = movieSessionProvider.voteResult;

      setState(
        () {
          votedMovies.add(movie);
          _currentIndex++;
          if (_currentIndex % 20 == 0) {
            _currentIndex = 0;
            fetchData(url(page));
          }
          //should switch go under the other code?
          switch (voteResult?.match) {
            case true:
              print("There was a match!: ${voteResult?.movieId}");
              var movieMatch = votedMovies
                  .firstWhere((element) => element.id == voteResult?.movieId);
              _displayBottomSheet(context, movieSessionProvider, movieMatch);
              print("The matching movie: ${movieMatch.title}");
              break;
            case false:
              print("Not a match!: $voteResult");
              break;
            default:
              break;
          }
        },
      );
    }

    return Dismissible(
      key: ValueKey<int>(movie.id),
      onDismissed: (DismissDirection direction) {
        handleSwipe(movie, direction == DismissDirection.endToStart);
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

  Future? _displayBottomSheet(
      BuildContext context, movieSessionProvider, Movie movie) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => SizedBox(
        height: 500,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              children: [
                const Text(
                  "There was a match!",
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        imagePath(movie.backdropPath),
                        fit: BoxFit.cover,
                        height: 220, // Set the height of the image
                      ),
                    ),
                    //OVERLAY
                    Opacity(
                      opacity: 0.5,
                      child: Container(
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black12,
                              Colors.black54,
                              Colors.black54,
                              Colors.black87,
                              Colors.black,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                Text(
                  movie.releaseDate,
                  style: const TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/welcome'),
                  child: const Text("Ok"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



/*
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff027DFD),
                        Color(0xff4100E0),
                        Color(0xff1CDAC5),
                      ],
                    ),
                  ),
                ),

*/