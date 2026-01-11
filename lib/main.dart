import 'package:flutter/material.dart';
import 'package:imposter/categoryCharacters.dart';
import 'package:imposter/homeScreen.dart';
import 'package:imposter/splashScreen.dart';

import 'Categories_page.dart';
import 'characterRevealScreen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SplashScreen.routeName,
      debugShowCheckedModeBanner: false,
      routes: {

        HomeScreen.routeName:(context)=>HomeScreen(),
        Categories_page.routeName:(context)=>const Categories_page(),
        SplashScreen.routeName:(context)=>const SplashScreen(),
      },
    );
  }
}
