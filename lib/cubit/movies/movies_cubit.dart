import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/movie_model.dart';

abstract class MoviesState {}
class MoviesInitial extends MoviesState {}
class MoviesLoading extends MoviesState {}
class MoviesSuccess extends MoviesState {
  final List<MovieModel> movies;
  MoviesSuccess(this.movies);
}
class SearchSuccess extends MoviesState {
  final List<MovieModel> movies;
  SearchSuccess(this.movies);
}
class MoviesError extends MoviesState {
  final String message;
  MoviesError(this.message);
}

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit() : super(MoviesInitial());

  List<MovieModel> allMovies = [];
  String selectedGenre = "All";



  Future<void> fetchMovies() async {
    emit(MoviesLoading());
    try {
      final response = await http.get(Uri.parse('https://yts.lt/api/v2/list_movies.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null && data['data']['movies'] != null) {
          allMovies = (data['data']['movies'] as List)
              .map((movie) => MovieModel.fromJson(movie))
              .toList();
          emit(MoviesSuccess(allMovies));
        } else {
          emit(MoviesError("No movies found in the API"));
        }
      } else {
        emit(MoviesError("Server Error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(MoviesError("Connection Error: ${e.toString()}"));
    }
  }
  void searchMovies(String query) {
    if (query.isEmpty) {
      emit(MoviesSuccess(allMovies));
    } else {
      final results = allMovies.where((movie) =>
          movie.title.toLowerCase().contains(query.toLowerCase())).toList();
      emit(SearchSuccess(results));
    }
  }
  ///  Get unique genres
  List<String> getGenres() {
    final genres = allMovies
        .expand((movie) => movie.genres)
        .toSet()
        .map((e) => e.toString())
        .toList();

    genres.insert(0, "All");
    return genres;
  }

  ///  Get filtered movies
  List<MovieModel> getFilteredMovies() {
    if (selectedGenre == "All") {
      return allMovies;
    }

    return allMovies
        .where((movie) => movie.genres.contains(selectedGenre))
        .toList();
  }

  /// Change selected genre
  void changeGenre(String genre) {
    selectedGenre = genre;
    emit(MoviesSuccess(allMovies)); // refresh UI
  }
}