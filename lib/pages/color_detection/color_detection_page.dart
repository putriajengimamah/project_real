// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'camera_service.dart';
// import 'color_utils.dart';
// import 'camera_preview_overlay.dart';
// import 'speech_helper.dart';

// class ColorDetectionPage extends StatefulWidget {
//   const ColorDetectionPage({Key? key}) : super(key: key);

//   @override
//   State<ColorDetectionPage> createState() => _ColorDetectionPageState();
// }

// class _ColorDetectionPageState extends State<ColorDetectionPage> {
//   late CameraService _cameraService;
//   String detectedColor = '';

//   @override
//   void initState() {
//     super.initState();
//     _cameraService = CameraService(
//       onColorDetected: (colorName) {
//         if (colorName != detectedColor) {
//           setState(() => detectedColor = colorName);
//           speakColor(colorName);
//         }
//       },
//     );
//     _cameraService.initCamera();
//   }

//   @override
//   void dispose() {
//     _cameraService.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           _cameraService.cameraPreviewWidget(),
//           const CameraPreviewOverlay(),
//           Positioned(
//             bottom: 50,
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.black87,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Text(
//                 detectedColor.isEmpty ? "Mendeteksi warna..." : detectedColor,
//                 style: const TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'camera_service.dart';
import 'camera_preview_overlay.dart';
import 'speech_helper.dart';
import 'dart:async';

class ColorDetectionPage extends StatefulWidget {
  const ColorDetectionPage({Key? key}) : super(key: key);

  @override
  State<ColorDetectionPage> createState() => _ColorDetectionPageState();
}

class _ColorDetectionPageState extends State<ColorDetectionPage> {
  late CameraService _cameraService;
  String detectedColor = '';
  String _lastSpokenColor = '';
  bool _cameraReady = false;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    initTts(); // Ini Tambahan
    _cameraService = CameraService(
      onColorDetected: (colorName) {
        if (!_isDetecting) return;
        if (colorName != detectedColor) {
          setState(() => detectedColor = colorName);
          if (colorName != _lastSpokenColor) {
            _lastSpokenColor = colorName;
            speakColor(colorName);
          }
        }
      },
    );
    _initialize();
  }

  Future<void> _initialize() async {
    await _cameraService.initCamera();
    setState(() => _cameraReady = true);

    // Tambahkan delay 3 detik sebelum deteksi warna dimulai
    await Future.delayed(const Duration(seconds: 3));
    setState(() => _isDetecting = true);
    _cameraService.startStream();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          _cameraReady
              ? _cameraService.cameraPreviewWidget()
              : const Center(child: CircularProgressIndicator()),
          if (_cameraReady) const CameraPreviewOverlay(),
          if (_cameraReady)
            Positioned(
              bottom: 50,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  detectedColor.isEmpty
                      ? (!_isDetecting
                          ? "Menunggu kamera..."
                          : "Mendeteksi warna...")
                      : detectedColor,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
