class MovieModel {
  final int id;
  final String title;
  final String year;
  final double rating;
  final int runtime;
  final String summary;
  final String image;
  final List<dynamic> genres;

  MovieModel({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.summary,
    required this.image,
    required this.genres,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      year: json['year'].toString(),
      rating: (json['rating'] as num).toDouble(),
      runtime: json['runtime'] ?? 0,
      summary: json['summary'] ?? "",
      image: json['large_cover_image'] ?? "",
      genres: json['genres'] ?? [],
    );
  }

  // ده التعديل
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'rating': rating,
      'runtime': runtime,
      'summary': summary,
      'large_cover_image': image,
      'genres': genres,
    };
  }
}