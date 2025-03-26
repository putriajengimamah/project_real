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

import 'package:flutter/material.dart';
import 'package:project_real/pages/home_page/widgets/home_appbar.dart';
import 'package:project_real/pages/home_page/widgets/home_menu.dart';
import 'package:project_real/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart'; // Tambahkan ini

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
  }

  /// Memeriksa izin saat halaman dimuat
  Future<void> _checkPermissions() async {
    bool hasPermissions = await PermissionService.checkPermissions();
    if (!hasPermissions) {
      bool granted = await PermissionService.requestPermissions();
      if (!granted) {
        // Jika pengguna menolak izin, arahkan ke pengaturan
        if (mounted) {
          _showPermissionDialog();
        }
      }
    }
  }

  /// Menampilkan dialog jika izin ditolak
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
              await openAppSettings(); // Buka pengaturan aplikasi
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
