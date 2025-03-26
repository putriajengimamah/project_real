import 'package:flutter/material.dart';

// Widget untuk logo aplikasi
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "See4Me",
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        const SizedBox(width: 3),
        Image.asset(
          "assets/images/Star.png",
          width: 28,
          height: 28,
        ),
      ],
    );
  }
}

// Widget untuk tagline aplikasi
class AppTagline extends StatelessWidget {
  const AppTagline({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Your Eyes, Our Innovation",
      style: TextStyle(fontSize: 16, color: Colors.white),
    );
  }
}
