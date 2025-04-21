import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart'; // Untuk SemanticsService
import 'package:permission_handler/permission_handler.dart';
import 'package:project_real/pages/home_page/widgets/home_appbar.dart';
import 'package:project_real/pages/home_page/widgets/home_menu.dart';
import 'package:project_real/services/permission_service.dart';
import 'package:project_real/utils/greeting_helper.dart'; // Import helper

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();

    // 🗣️ Baca greeting saat halaman dibuka
    final greeting = getGreeting();
    SemanticsService.announce(greeting, TextDirection.ltr);
  }

  Future<void> _checkPermissions() async {
    bool hasPermissions = await PermissionService.checkPermissions();
    if (!hasPermissions) {
      bool granted = await PermissionService.requestPermissions();
      if (!granted && mounted) {
        _showPermissionDialog();
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Izin Diperlukan"),
        content: const Text(
          "Aplikasi ini memerlukan akses ke kamera dan mikrofon. "
          "Silakan izinkan akses di pengaturan.",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text("Buka Pengaturan"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: HomeMenu(),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:project_real/pages/home_page/widgets/home_appbar.dart';
// import 'package:project_real/pages/home_page/widgets/home_menu.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       appBar: HomeAppBar(), // Bagian atas (AppBar dengan sapaan)
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: HomeMenu(), // Bagian menu utama (Grid)
//         ),
//       ),
//     );
//   }
// }

