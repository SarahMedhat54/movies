import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:move/screens/forgetpassword/forget_password.dart';
import 'package:move/screens/login/login_screen.dart';
import 'package:move/screens/onboarding/onboarding_screen.dart';
import 'package:move/screens/register/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    // home: ForgetPassword(),
     //home : RegisterScreen(),
     // home: LoginScreen(),

      home: OnboardingScreen(),

      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
