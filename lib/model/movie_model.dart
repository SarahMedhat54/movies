class MovieModel {
  final int id;
  final String title;
  final String year;
  final double rating;
  final String largeCoverImage;
  final List<dynamic> genres;

  MovieModel({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.largeCoverImage,
    required this.genres,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      year: json['year'].toString(),
      rating: (json['rating'] as num).toDouble(),
      largeCoverImage: json['large_cover_image'],
      genres: json['genres'] ?? [],
    );
  }
}