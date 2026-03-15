import 'package:flutter/material.dart';
import 'package:move/screens/forgetpassword/forget_password.dart';

import '../screens/login/login_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/register/register_screen.dart';

abstract final class AppRoutes {
  static MaterialPageRoute get login =>
      MaterialPageRoute(builder: (_) => LoginScreen());
  static MaterialPageRoute get register =>
      MaterialPageRoute(builder: (_) => RegisterScreen());

  static MaterialPageRoute get forgetPassword =>
      MaterialPageRoute(builder: (_) => ForgetPassword());
  static MaterialPageRoute get onboarding =>
      MaterialPageRoute(builder: (_) => OnboardingScreen());

  static MaterialPageRoute get profile =>
      MaterialPageRoute(builder: (_) => ProfileScreen());
}