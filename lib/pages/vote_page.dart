import 'package:flutter/material.dart';
import 'package:movie_night_app/provider/movie_session_provider.dart';
import 'package:provider/provider.dart';
import 'package:movie_night_app/data/models/movie_model.dart';
import 'package:movie_night_app/data/http_helper.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VotePage extends StatefulWidget {
  const VotePage({Key? key}) : super(key: key);

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage>
    with SingleTickerProviderStateMixin {
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
                  return _movieDismissible(
                    movieSessionProvider,
                    snapshot.data![_currentIndex],
                  );
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

//dismissible widget that renders the card
  Widget _movieDismissible(
      MovieSessionProvider movieSessionProvider, Movie movie) {
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
              var movieMatch = votedMovies
                  .firstWhere((element) => element.id == voteResult?.movieId);
              _displayBottomSheet(context, movieSessionProvider, movieMatch);
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
        handleSwipe(movie, direction == DismissDirection.startToEnd);
      },
      //vote yes
      background: const Icon(
        Icons.favorite,
        size: 250,
      ),
      //vote no
      secondaryBackground: Icon(
        Icons.heart_broken_rounded,
        size: 250,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: _movieCard(movie)
          .animate()
          .fade(duration: 250.ms)
          .slide(curve: Curves.easeInOut),
    );
  }

//movie card
  Widget _movieCard(Movie movie) {
    var movieImage = imagePath(movie.posterPath);

    return SizedBox(
      height: 500,
      child: Card(
        elevation: 40,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                fadeInDuration: 300.ms,
                image: imagePath(movieImage),
                width: 500,
                fit: BoxFit.cover),
            Container(
              //gradient overlay
              height: 500,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.75),
                    Colors.black.withOpacity(1.0),
                  ],
                  stops: const [0.0, 0.25, 0.5, 1.0],
                ),
              ),
            ),
            _movieData(movie)
          ],
        ),
      ),
    );
  }

// displays the movie info (title + ratings etc.)
  Widget _movieData(Movie movie) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //moves my movie info to the bottom of the card
            const SizedBox(height: 325),
            Row(
              children: [
                Expanded(
                  child: Text(
                    movie.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                      .animate()
                      .fade(duration: 250.ms, delay: 250.ms)
                      .slide(curve: Curves.easeIn),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    movie.voteAverage.toStringAsFixed(1).toString(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                )
                    .animate()
                    .fade(duration: 250.ms, delay: 250.ms)
                    .slide(curve: Curves.easeIn),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    movie.releaseDate,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  )
                      .animate()
                      .fade(duration: 250.ms, delay: 250.ms)
                      .slide(curve: Curves.easeIn),
                ),
              ],
            )
          ],
        ));
  }

// display movie match
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
                    color: Colors.white,
                  ),
                ),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        imagePath(movie.backdropPath),
                        fit: BoxFit.cover,
                        height: 220,
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
                    color: Colors.white,
                  ),
                ),
                Text(
                  movie.releaseDate,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      //go back to welcome screen and reset nav stack
                      Navigator.of(context).popUntil((route) => route.isFirst),
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
