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

/*
{
  "dates":{
      "maximum":"2023-12-06",
      "minimum":"2023-10-25"
  },
  "page":1,
  "results":[
      {
        "adult":false,
        "backdrop_path":"/9PqD3wSIjntyJDBzMNuxuKHwpUD.jpg",
        "genre_ids":[
            16,
            35,
            10751
        ],
        "id":1075794,
        "original_language":"en",
        "original_title":"Leo",
        "overview":"Jaded 74-year-old lizard Leo has been stuck in the same Florida classroom for decades with his terrarium-mate turtle. When he learns he only has one year left to live, he plans to escape to experience life on the outside but instead gets caught up in the problems of his anxious students — including an impossibly mean substitute teacher.",
        "popularity":2210.105,
        "poster_path":"/pD6sL4vntUOXHmuvJPPZAgvyfd9.jpg",
        "release_date":"2023-11-17",
        "title":"Leo",
        "video":false,
        "vote_average":7.588,
        "vote_count":391
      },
*/