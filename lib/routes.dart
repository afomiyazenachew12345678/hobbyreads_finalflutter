import 'package:flutter/material.dart';
import 'package:hobby_reads_flutter/screens/landing/landing_screen.dart';
import 'package:hobby_reads_flutter/screens/auth/login_screen.dart';
import 'package:hobby_reads_flutter/screens/auth/register_screen.dart';
import 'package:hobby_reads_flutter/screens/home/home_screen.dart';

class AppRoutes {
  static const String landing = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String books = '/books';
  static const String trades = '/trades';
  static const String connections = '/connections';

  static Map<String, WidgetBuilder> get routes => {
    landing: (context) => const LandingScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    // Add other routes as they are implemented
  };
} 