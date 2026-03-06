import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../model/movie_model.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: movie.largeCoverImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(color: AppColors.lightBlack),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),

          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    movie.rating.toString(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, color: AppColors.yellow, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}