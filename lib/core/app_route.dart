import 'package:flutter/material.dart';

import '../screens/login/login_screen.dart';

abstract final class AppRoutes {
  static MaterialPageRoute get login =>
      MaterialPageRoute(builder: (_) => LoginScreen());

}