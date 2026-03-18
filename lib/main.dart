import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move/cubit/movies/movies_cubit.dart';
import 'package:move/screens/onboarding/onboarding_screen.dart';
import 'package:move/core/cache_helper.dart';
import 'package:move/screens/login/login_screen.dart';
import 'package:move/screens/main_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCQkLzW6M2re82kVF55lzJbIH0SMVCj1k4",
      appId: "1:450728628496:android:4cdc5bfb5a8a7ad10d9595",
      messagingSenderId: "",
      projectId: "movies-cb885",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoviesCubit()..fetchMovies(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CacheHelper.isLoggedIn()
            ? const MainScreen()
            : (CacheHelper.isSkippedOnboarding()
                  ? const LoginScreen()
                  : const OnboardingScreen()),
      ),
    );
  }
}
