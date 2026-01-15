import 'package:flutter/material.dart';
import 'package:imposter/categoryCharacters.dart';
import 'package:imposter/homeScreen.dart';
import 'package:imposter/mCQScreen.dart';
import 'package:imposter/Categories_page.dart';

// Import new screens
import 'package:imposter/guessImposterScreen.dart';
import 'package:imposter/finalResultScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomeScreen.routeName,
      debugShowCheckedModeBanner: false,
      routes: {
        // Existing routes
        HomeScreen.routeName: (context) => HomeScreen(),
        Categories_page.routeName: (context) => const Categories_page(),
        CategoryCharacters.routeName: (context) => const CategoryCharacters(),

        // New routes for the updated game flow
        GuessImposterScreen.routeName: (context) => const GuessImposterScreen(),
        MCQScreen.routeName: (context) => const MCQScreen(),
        FinalResultScreen.routeName: (context) => const FinalResultScreen(),
      },
    );
  }
}