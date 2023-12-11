class Movie {
  late int id;
  late String title;
  late String releaseDate;
  late double popularity;
  late double voteAverage;
  late int voteCount;
  late String? posterPath;
  late String? backdropPath;

  Movie.fromJson(Map<String, dynamic> res) {
    id = res['id'];
    title = res['original_title'];
    releaseDate = res['release_date'];
    popularity = res['popularity'];
    voteAverage = res['vote_average'];
    voteCount = res['vote_count'];
    posterPath = res['poster_path'];
    backdropPath = res['backdrop_path'];
  }
}
