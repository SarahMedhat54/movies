import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move/core/app_style.dart';
import '../../cubit/movies/movies_cubit.dart';
import '../../core/app_colors.dart';
import '../../model/movie_model.dart';
import '../../widget/custom_movie_card.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String selectedGenre = "All";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MoviesCubit()..fetchMovies(),
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: BlocBuilder<MoviesCubit, MoviesState>(
          builder: (context, state) {
            if (state is MoviesLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.yellow),
              );
            }
            if (state is MoviesSuccess) {
              final genresList = state.movies
                  .expand((movie) => movie.genres)
                  .toSet()
                  .map((e) => e.toString())
                  .toList();
              genresList.insert(0, "All");
              List<MovieModel> filteredMovies;

              if (selectedGenre == "All") {
                filteredMovies = state.movies;
              } else {
                filteredMovies = state.movies
                    .where((movie) => movie.genres.contains(selectedGenre))
                    .toList();
              }
              return SafeArea(
                child: Container(
                  color: AppColors.black,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: genresList.length,
                          itemBuilder: (context, index) {

                            final genre = genresList[index];
                            final isSelected = selectedGenre == genre;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedGenre = genre;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.yellow
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.yellow,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  genre,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : AppColors.yellow,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 15),
                      CustomMovieCard(numCard: 2,filteredMovies: filteredMovies,),
                    ],
                  ),
                ),
              );
            }

            if (state is MoviesError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}