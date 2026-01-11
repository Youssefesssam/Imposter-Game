import 'package:flutter/material.dart';
import 'package:imposter/categoryCharacters.dart';


class HomeScreen extends StatelessWidget {
  static const String routeName ='HomeScreen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CategoryCharacters(),
    );
  }
}
