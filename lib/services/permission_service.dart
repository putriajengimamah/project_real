import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Memeriksa dan meminta izin kamera & audio
  static Future<bool> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final audioStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && audioStatus.isGranted) {
      return true; // Semua izin diberikan
    }

    return false; // Salah satu atau kedua izin ditolak
  }

  /// Mengecek apakah semua izin sudah diberikan sebelumnya
  static Future<bool> checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final audioStatus = await Permission.microphone.status;

    return cameraStatus.isGranted && audioStatus.isGranted;
  }
}
