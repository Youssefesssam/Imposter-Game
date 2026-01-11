import 'package:flutter/material.dart';
import 'package:imposter/Categories_page.dart';
import 'dart:async';

import 'package:imposter/utilites.dart'; // مهم للـ Timer

class SplashScreen extends StatefulWidget {
  static const String routeName ='SplashScreen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ننتظر 3 ثواني وبعدين نروح للصفحة الرئيسية
    Timer(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, Categories_page.routeName);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.splashScreen,fit: BoxFit.cover,
    );
  }
}
