import 'package:flutter/material.dart';
import 'pages/splash_screen/splash_screen.dart';
import 'pages/home_page/home_page.dart';
import 'pages/scan_page/scan_text.dart';
import 'pages/color_detection/color_detection_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/scan_text': (context) => ScanText(),
        '/color_detection': (context) => const ColorDetectionPage(),
      },
    );
  }
}
