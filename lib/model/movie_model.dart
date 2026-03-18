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
  factory MovieModel.fromFirestore(Map<String, dynamic> json) {
    return MovieModel(
      id: json['movieId'] ?? 0,
      title: json['title'] ?? "",
      year: json['year']?.toString() ?? "",
      rating: (json['rating'] ?? 0.0).toDouble(),
      runtime: json['runtime'] ?? 0,
      summary: json['summary'] ?? "",
      image: json['image'] ?? "",
      genres: json['genres'] ?? [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "movieId": id,
      "title": title,
      "image": image,
      "rating": rating,
      "runtime": runtime,
      "year": year,
      "summary": summary,
      "genres": genres,
    };
  }
}
