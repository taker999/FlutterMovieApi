class Movie {
  Movie({
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
  });
  late final String overview;
  late final String posterPath;
  late final String releaseDate;
  late final String title;
  late final double voteAverage;

  Movie.fromJson(Map<String, dynamic> json){
    overview = json['overview'];
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'];
    voteAverage = json['vote_average'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['overview'] = overview;
    data['poster_path'] = posterPath;
    data['release_date'] = releaseDate;
    data['title'] = title;
    data['vote_average'] = voteAverage;
    return data;
  }
}
