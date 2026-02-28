import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import '../../cubit/movies/movies_cubit.dart';
import '../../core/app_colors.dart';
import '../../core/app_assets.dart';
import '../../widget/movie_cerd.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
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
              return const Center(
                child: CircularProgressIndicator(color: AppColors.yellow),
              );
            } else if (state is MoviesSuccess) {

              if (_selectedMovieImage.isEmpty && state.movies.isNotEmpty) {
                _selectedMovieImage = state.movies[0].largeCoverImage;
              }

              return Stack(
                children: [

                  _buildBlurredBackground(),

                  SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),


                        Image.asset(
                          AppAssets.AvailableNow,
                          height: 35,
                          fit: BoxFit.contain,
                        ),

                        const Spacer(),


                        carousel.CarouselSlider.builder(
                          itemCount: state.movies.length,
                          itemBuilder: (context, index, realIndex) {
                            return MovieCard(movie: state.movies[index]);
                          },
                          options: carousel.CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.55,
                            enlargeCenterPage: true,
                            viewportFraction: 0.7,
                            onPageChanged: (index, reason) {
                              setState(() {

                                _selectedMovieImage = state.movies[index].largeCoverImage;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Watch Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is MoviesError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            return const SizedBox();
          },
        ),
        bottomNavigationBar: _buildBottomNav(),
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
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
    );
  }


  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      backgroundColor: AppColors.lightBlack,
      selectedItemColor: AppColors.yellow,
      unselectedItemColor: AppColors.white,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => setState(() => _currentIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}