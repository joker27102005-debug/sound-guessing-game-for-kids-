import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'routes/app_routes.dart';
import 'features/profile/screens/name_entry_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/game/screens/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.nameEntry,
      routes: {
        AppRoutes.nameEntry: (_) => const NameEntryScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.game: (_) => const GameScreen(),
      },
    );
  }
}
