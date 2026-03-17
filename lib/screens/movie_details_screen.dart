import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:move/model/movie_model.dart';
import 'package:move/screens/profile/history_manager.dart';

import '../firebase/firebase_store.dart';

import '../firebase/firebase_store.dart';
import '../model/user_data.dart';


class MovieDetailsScreen extends StatefulWidget {
  final MovieModel movie;
  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool isBookmarked=false;
  @override
  void initState() {
    super.initState();
    loadBookmark();
    HistoryManager.addMovie(widget.movie);
  }
  void loadBookmark() async {
    bool exist = await isMovieBookmarked(widget.movie);

    if (!mounted) return;

    setState(() {
      isBookmarked = exist;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  widget.movie.image,
                  height: 600,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 600,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF121312).withOpacity(0.9),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon: Icon(
                      isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {

                      await toggleWatchList(widget.movie);

                      setState(() {
                        isBookmarked = !isBookmarked;
                      });

                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text("Movie added to Watch List"),
                      //   ),
                      // );
                    },
                  ),
                ),

                const Icon(Icons.play_circle_fill, color: Color(0xFFFFBB3B), size: 80),

                Positioned(
                  bottom: 20,
                  child: Column(
                    children: [
                      Text(
                        widget.movie.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "2024",
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 15),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE82626),
                          fixedSize: const Size(300, 45),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {},
                        child: const Text("Watch", style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatItem(Icons.favorite, "15", const Color(0xFFFFBB3B)),
                          const SizedBox(width: 20),
                          _buildStatItem(Icons.access_time, "${widget.movie.runtime}", const Color(0xFFFFBB3B)),
                          const SizedBox(width: 20),
                          _buildStatItem(Icons.star, "${widget.movie.rating}", const Color(0xFFFFBB3B)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Summary",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.movie.summary,
                    style: const TextStyle(color: Color(0xFFCBC9C9), fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}