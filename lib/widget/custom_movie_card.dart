import 'package:flutter/material.dart';
import 'package:move/widget/movie_cerd.dart';

import '../core/app_colors.dart';
import '../core/app_style.dart';

class CustomMovieCard extends StatelessWidget {
  int numCard;
  List filteredMovies=[];

   CustomMovieCard({super.key,required this.numCard,
     required this.filteredMovies});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate:
         SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: numCard,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        itemCount: filteredMovies.length,
        itemBuilder: (context, index) {
          final movie = filteredMovies[index];

          return MovieCard(movie: movie);
        },
      ),
    );
  }
}
