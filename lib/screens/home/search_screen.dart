import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move/cubit/movies/movies_cubit.dart';
import 'package:move/widget/movie_cerd.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: TextField(
          style: const TextStyle(color: Colors.white),
          onChanged: (query) => context.read<MoviesCubit>().searchMovies(query),
          decoration: const InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Color(0xFFC6C6C6)),
            prefixIcon: Icon(Icons.search, color: Colors.white),
            border: InputBorder.none,
          ),
        ),
      ),
      body: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (context, state) {
          if (state is SearchSuccess && state.movies.isNotEmpty) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: state.movies.length,
              itemBuilder: (context, index) => MovieCard(movie: state.movies[index]),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_movies, color: Color(0xFF514F4F), size: 100),
                const SizedBox(height: 10),
                Text("No movies found", style: TextStyle(color: Colors.white.withOpacity(0.6))),
              ],
            ),
          );
        },
      ),
    );
  }
}