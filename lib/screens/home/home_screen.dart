import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import '../../cubit/movies/movies_cubit.dart';
import '../../core/app_colors.dart';
import '../../core/app_assets.dart';
import '../../widget/custome_bottomBar.dart';
import '../../widget/movie_cerd.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //int _currentIndex = 0;
  String _selectedMovieImage = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoviesCubit()..fetchMovies(),
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: BlocBuilder<MoviesCubit, MoviesState>(
          builder: (context, state) {
            if (state is MoviesLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.yellow));
            } else if (state is MoviesSuccess) {
              if (_selectedMovieImage.isEmpty && state.movies.isNotEmpty) {
                _selectedMovieImage = state.movies[0].largeCoverImage;
              }

              return Stack(
                children: [

                  _buildBlurredBackground(),

                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: SafeArea(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Image.asset(AppAssets.AvailableNow, height: 30),
                              const SizedBox(height: 15),


                              carousel.CarouselSlider.builder(
                                itemCount: state.movies.length,
                                itemBuilder: (context, index, realIndex) {
                                  return MovieCard(movie: state.movies[index]);
                                },
                                options: carousel.CarouselOptions(
                                  height: MediaQuery.of(context).size.height * 0.43,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.62,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _selectedMovieImage = state.movies[index].largeCoverImage;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 15),
                              Image.asset(AppAssets.WatchNow, width: 200),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Action", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("See More >", style: TextStyle(color: AppColors.yellow, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),

                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.65,
                          ),
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final movie = state.movies[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    Image.network(
                                        movie.largeCoverImage,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity
                                    ),

                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.7),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.star, color: AppColors.yellow, size: 12),
                                            const SizedBox(width: 3),
                                            Text(
                                              movie.rating.toString(),
                                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            childCount: state.movies.length,
                          ),
                        ),
                      ),

                      const SliverToBoxAdapter(
                        child: SizedBox(height: 120),
                      ),
                    ],
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
       // bottomNavigationBar: _buildBottomNav(),

      ),
    );
  }

  Widget _buildBlurredBackground() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: Container(
        key: ValueKey(_selectedMovieImage),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(_selectedMovieImage),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(color: Colors.black.withValues(alpha: 0.6)),
        ),
      ),
    );
  }

  // Widget _buildBottomNav() {
  //   return BottomNavigationBar(
  //     currentIndex: _currentIndex,
  //     backgroundColor: AppColors.lightBlack.withValues(alpha: 0.9),
  //     selectedItemColor: AppColors.yellow,
  //     unselectedItemColor: Colors.white,
  //     type: BottomNavigationBarType.fixed,
  //     onTap: (index) => setState(() => _currentIndex = index),
  //     items: const [
  //       BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
  //       BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
  //       BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
  //       BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  //     ],
  //   );
  // }
}