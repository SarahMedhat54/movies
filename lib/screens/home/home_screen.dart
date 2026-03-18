import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import '../../cubit/movies/movies_cubit.dart';
import '../../core/app_colors.dart';
import '../../core/app_assets.dart';
import '../../widget/custome_bottomBar.dart';
import '../../widget/movie_cerd.dart';
import '../movie_details_screen.dart';
import 'search_screen.dart';


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
    return Scaffold(
      backgroundColor: AppColors.black,
      body: _currentIndex == 0
          ? _buildHomeContent()
          : (_currentIndex == 1 ? const SearchScreen() : const Center(child: Text("Coming Soon", style: TextStyle(color: Colors.white)))),
      //bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeContent() {
    return BlocBuilder<MoviesCubit, MoviesState>(
      builder: (context, state) {
        if (state is MoviesLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.yellow));
        } else if (state is MoviesSuccess || state is SearchSuccess) {
          final movies = (state is MoviesSuccess) ? state.movies : (state as SearchSuccess).movies;

          if (_selectedMovieImage.isEmpty && movies.isNotEmpty) {
            String proxyUrl = 'https://external-content.duckduckgo.com/iu/?u=${movies[0].image}';

            _selectedMovieImage = proxyUrl;
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
                            itemCount: movies.length,
                            itemBuilder: (context, index, realIndex) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailsScreen(movie: movies[index]),
                                    ),
                                  ).then((_) {
                                    setState(() {});
                                  });
                                },
                                child: MovieCard(movie: movies[index]),
                              );
                            },
                            options: carousel.CarouselOptions(
                              height: MediaQuery.of(context).size.height * 0.43,
                              enlargeCenterPage: true,
                              viewportFraction: 0.62,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  String proxyUrl = 'https://external-content.duckduckgo.com/iu/?u=${movies[index].image}';
                                  _selectedMovieImage = proxyUrl;
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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.65,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final movie = movies[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailsScreen(movie: movie),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: MovieCard(movie: movie)
                            ),
                          );
                        },
                        childCount: movies.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],

              ),
            ],
          );
        }
        return const Center(child: Text("No Movies Found", style: TextStyle(color: Colors.white)));
      },

    );
  }

  Widget _buildBlurredBackground() {
    return _selectedMovieImage.isEmpty
        ? Container(color: Colors.black)
        : AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: Container(
        key: ValueKey(_selectedMovieImage),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(_selectedMovieImage),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(color: Colors.black.withOpacity(0.6)),
        ),
      ),
    );
  }

}