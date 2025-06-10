import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hobby_reads_flutter/providers/app_providers.dart';
import 'package:hobby_reads_flutter/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppProviders()..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'Hobby Reads',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
