import '../../model/movie_model.dart';


class HistoryManager {
  static List<MovieModel> historyMovies = [];

  static void addMovie(MovieModel movie) {


    if (!historyMovies.any((m) => m.id == movie.id)) {
      historyMovies.insert(0, movie);
    }

  }
}
