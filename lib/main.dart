import 'package:flutter/material.dart';
import 'package:hobby_reads_flutter/screens/admin/add_hobby_screen.dart';
import 'package:hobby_reads_flutter/screens/admin/admin_dashboard_screen.dart';
import 'package:hobby_reads_flutter/screens/admin/hobbies_screen.dart';
import 'package:hobby_reads_flutter/screens/admin/users_screen.dart';
import 'package:hobby_reads_flutter/screens/auth/login_screen.dart';
import 'package:hobby_reads_flutter/screens/auth/register_screen.dart';
import 'package:hobby_reads_flutter/screens/books/add_book_screen.dart';
import 'package:hobby_reads_flutter/screens/books/books_screen.dart';
import 'package:hobby_reads_flutter/screens/connections/connections_screen.dart';
import 'package:hobby_reads_flutter/screens/home/home_screen.dart';
import 'package:hobby_reads_flutter/screens/landing/landing_screen.dart';
import 'package:hobby_reads_flutter/screens/profile/profile_screen.dart';
import 'package:hobby_reads_flutter/screens/trades/trade_requests_screen.dart';
import 'package:hobby_reads_flutter/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HobbyReads',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/books': (context) => const BooksScreen(),
        '/add-book': (context) => const AddBookScreen(),
        '/connections': (context) => const ConnectionsScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/admin/users': (context) => const AdminUsersScreen(),
        '/admin/hobbies': (context) => const AdminHobbiesScreen(),
        '/admin/hobbies/add': (context) => const AddHobbyScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/trades': (context) => const TradeRequestsScreen(),
      },
    );
  }
}
