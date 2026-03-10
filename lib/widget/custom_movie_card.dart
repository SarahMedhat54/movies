import 'package:flutter/material.dart';

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

          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie.image,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                          movie.rating.toString(),
                          style: AppTextStyle.white16w400
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.star, color: AppColors.yellow, size: 12),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
