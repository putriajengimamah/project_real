// [KODE YANG UDAH AKU TAMBAHIN SEMANTICS BUAT OPTIMALIN FITUR TALKBACK]

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Wajib untuk SemanticsService
import '../../components/components.dart';
import 'package:flutter/semantics.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        const Duration(milliseconds: 300),
      ); // Tambah jeda sedikit lebih panjang
      SemanticsService.announce(
        "Selamat datang di aplikasi See for Me. Slogan kami, Your Eyes, Our Innovation.",
        TextDirection.ltr,
      );
    });

    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    await Future.delayed(const Duration(seconds: 7));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0E6AC7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [AppLogo(), SizedBox(height: 4), AppTagline()],
        ),
      ),
    );
  }
}

// [KODE YANG BELUM AKU TAMBAHIN SEMANTICS BUAT OPTIMALIN FITUR TALKBACK]
// import 'package:flutter/material.dart';
// import '../../components/components.dart'; // Import widget reusable

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       Future.delayed(const Duration(seconds: 3), () {
//         Navigator.of(context).pushReplacementNamed('/home');
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0E6AC7),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             AppLogo(), // Panggil widget logo
//             SizedBox(height: 4),
//             AppTagline(), // Panggil widget tagline
//           ],
//         ),
//       ),
//     );
//   }
// }
