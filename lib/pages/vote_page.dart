import 'package:flutter/material.dart';
import 'package:movie_night_app/provider/movie_session_provider.dart';
import 'package:provider/provider.dart';
import 'package:movie_night_app/data/models/movie_model.dart';
import 'package:movie_night_app/data/http_helper.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:movie_night_app/custom_widgets/gradient_btn.dart';

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
      print("Error fetching data: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieSessionProvider>(
      builder: (context, movieSessionProvider, child) => Scaffold(
        appBar: AppBar(
            foregroundColor: Theme.of(context).colorScheme.onBackground,
            title: const Text('ReelSync'),
            backgroundColor: Theme.of(context).colorScheme.background),
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
              break;
            default:
              break;
          }
        },
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text("Popular Movies",
                style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        const Spacer(),
        Dismissible(
          key: ValueKey<int>(movie.id),
          onDismissed: (DismissDirection direction) {
            handleSwipe(movie, direction == DismissDirection.startToEnd);
          },
          background: _swipeIcon(true),
          secondaryBackground: _swipeIcon(false),
          child: _movieCard(movie)
              .animate()
              .fade(duration: 250.ms)
              .slide(curve: Curves.easeInOut),
        ),
        const Spacer(),
      ],
    );
  }

//movie card
  Widget _movieCard(Movie movie) {
    var movieImage = imagePath(movie.posterPath);
    print(imagePath(movie.backdropPath));
    return SizedBox(
      height: 500,
      child: Card(
        elevation: 40,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                fadeInDuration: 250.ms,
                fadeInCurve: Curves.easeIn,
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

// Styling for the movie info inside the card
  Widget _movieData(Movie movie) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 325),
          Row(
            children: [
              Expanded(
                  child: Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
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
            ],
          ),
          const SizedBox(height: 8),
          Divider(
            height: .75,
            thickness: .75,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              cardDetails("Released", movie.releaseDate),
              cardDetails("Popularity", movie.popularity.round().toString()),
              cardDetails("Votes", movie.voteCount.round().toString())
            ],
          )
        ],
      )
          .animate()
          .fade(duration: 250.ms, delay: 150.ms)
          .slide(curve: Curves.easeInOut),
    );
  }

//Vote count, release date, popularity..
  Widget cardDetails(String detailTitle, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detailTitle,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        Text(
          detail,
          style: Theme.of(context).textTheme.labelMedium,
        )
      ],
    );
  }

// display movie match bottom sheet
  Future? _displayBottomSheet(
      BuildContext context, movieSessionProvider, Movie movie) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => SizedBox(
        height: 400,
        child: Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.background,
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: NetworkImage(
                imagePath(movie.backdropPath),
              ),
            ),
          ),
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(16),
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
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 225,
                      width: 175,
                      padding: const EdgeInsets.only(right: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imagePath(movie.posterPath),
                          fit: BoxFit.fitWidth,
                          height: 220,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Match!",
                            style: Theme.of(context).textTheme.labelMedium),
                        Text(movie.title,
                            maxLines: 5,
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 8),
                        Divider(
                            height: .75,
                            thickness: .75,
                            color: Theme.of(context).colorScheme.onSurface),
                        const SizedBox(height: 8),
                        Text(movie.releaseDate,
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    )),
                  ],
                ),
                const Spacer(),
                GradientButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  btnText: "Ok",
                  gradientColors: [
                    Theme.of(context).colorScheme.onPrimary,
                    Theme.of(context).colorScheme.primary,
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

//Dismissible background icon animation
  Widget _swipeIcon(bool vote) {
    if (vote == true) {
      return Animate(
        effects: const [
          ScaleEffect(
            duration: Duration(milliseconds: 500),
            begin: Offset(5, 5),
            end: Offset(7, 7),
            curve: Curves.ease,
          ),
          ShimmerEffect(
              duration: Duration(milliseconds: 600),
              color: Colors.red,
              curve: Curves.easeOut),
        ],
        child: Icon(
          Icons.favorite_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      );
    } else {
      return Animate(
        effects: const [
          ScaleEffect(
            duration: Duration(milliseconds: 500),
            begin: Offset(7, 7),
            end: Offset(5, 5),
            curve: Curves.easeInOut,
          ),
          ShakeEffect(
            duration: Duration(milliseconds: 1500),
          )
        ],
        child: Icon(
          Icons.heart_broken_rounded,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
  }
}
