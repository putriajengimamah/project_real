// import 'package:camera/camera.dart';
// import 'dart:async';
// import 'dart:typed_data';
// import 'color_utils.dart';
// import 'package:flutter/material.dart';

// typedef ColorCallback = void Function(String colorName);

// class CameraService {
//   late CameraController _controller;
//   late List<CameraDescription> _cameras;
//   final ColorCallback onColorDetected;
//   Timer? _timer;

//   CameraService({required this.onColorDetected});

//   Future<void> initCamera() async {
//     _cameras = await availableCameras();
//     _controller = CameraController(
//       _cameras.first,
//       ResolutionPreset.low,
//       enableAudio: false,
//     );
//     await _controller.initialize();
//     _controller.startImageStream(_processCameraImage);
//   }

//   void _processCameraImage(CameraImage image) {
//     if (_timer?.isActive ?? false) return;
//     _timer = Timer(const Duration(seconds: 1), () {}); // 1 detik delay

//     final bytes = image.planes[0].bytes;
//     final width = image.width;
//     final height = image.height;
//     final centerX = width ~/ 2;
//     final centerY = height ~/ 2;
//     final pixelIndex = centerY * width + centerX;

//     if (pixelIndex < bytes.length - 3) {
//       final r = bytes[pixelIndex];
//       final g = bytes[pixelIndex + 1];
//       final b = bytes[pixelIndex + 2];
//       final colorName = getColorNameFromRGB(r, g, b);
//       onColorDetected(colorName);
//     }
//   }

//   Widget cameraPreviewWidget() => _controller.value.isInitialized
//       ? CameraPreview(_controller)
//       : const Center(child: CircularProgressIndicator());

//   void dispose() {
//     _controller.dispose();
//     _timer?.cancel();
//   }
// }

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

typedef ColorCallback = void Function(String colorName);

class CameraService {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  final ColorCallback onColorDetected;
  Timer? _timer;

  CameraService({required this.onColorDetected});

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras.first,
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await _controller.initialize();
  }

  void startStream() {
    _controller.startImageStream(_processCameraImage);
  }

  void _processCameraImage(CameraImage image) {
    if (_timer?.isActive ?? false) return;
    _timer = Timer(const Duration(seconds: 1), () {}); // Delay antar deteksi

    try {
      // Mengkonversi YUV ke gambar RGB
      final img.Image convertedImage = _convertYUV420toImage(image);
      final int centerX = convertedImage.width ~/ 2;
      final int centerY = convertedImage.height ~/ 2;

      // Mengambil pixel pada koordinat tengah
      final img.Pixel pixel = convertedImage.getPixel(centerX, centerY);
      final int r = pixel.r.toInt();
      final int g = pixel.g.toInt();
      final int b = pixel.b.toInt();

      final colorName = getColorNameFromRGB(r, g, b);
      onColorDetected(colorName);
    } catch (e) {
      debugPrint('Gagal konversi gambar: $e');
    }
  }

  img.Image _convertYUV420toImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel ?? 1;

    final img.Image imgBuffer = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex = (y ~/ 2) * uvRowStride + (x ~/ 2) * uvPixelStride;
        final int index = y * width + x;

        final int yp = image.planes[0].bytes[index];
        final int up = image.planes[1].bytes[uvIndex];
        final int vp = image.planes[2].bytes[uvIndex];

        int r = (yp + 1.370705 * (vp - 128)).round();
        int g = (yp - 0.337633 * (up - 128) - 0.698001 * (vp - 128)).round();
        int b = (yp + 1.732446 * (up - 128)).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        imgBuffer.setPixelRgb(x, y, r, g, b);
      }
    }

    return imgBuffer;
  }

  String getColorNameFromRGB(int r, int g, int b) {
    final double hue = _getHue(r, g, b);
    final double brightness = (r + g + b) / 3;

    if (brightness < 40) return "Hitam";
    if (brightness > 220) return "Putih";
    if ((r - g).abs() < 15 && (g - b).abs() < 15) return "Abu-abu";

    if (hue >= 0 && hue < 15) return "Merah";
    if (hue >= 15 && hue < 45) return "Oranye";
    if (hue >= 45 && hue < 65) return "Kuning";
    if (hue >= 65 && hue < 170) return "Hijau";
    if (hue >= 170 && hue < 260) return "Biru";
    if (hue >= 260 && hue < 290) return "Ungu";
    if (hue >= 290 && hue < 330) return "Pink";
    return "Tak dikenal";
  }

  double _getHue(int r, int g, int b) {
    final double rf = r / 255;
    final double gf = g / 255;
    final double bf = b / 255;

    final double max = [rf, gf, bf].reduce((a, b) => a > b ? a : b);
    final double min = [rf, gf, bf].reduce((a, b) => a < b ? a : b);

    double hue = 0;

    if (max == min) {
      hue = 0;
    } else if (max == rf) {
      hue = (60 * ((gf - bf) / (max - min)) + 360) % 360;
    } else if (max == gf) {
      hue = (60 * ((bf - rf) / (max - min)) + 120) % 360;
    } else if (max == bf) {
      hue = (60 * ((rf - gf) / (max - min)) + 240) % 360;
    }

    return hue;
  }

  Widget cameraPreviewWidget() =>
      _controller.value.isInitialized
          ? CameraPreview(_controller)
          : const Center(child: CircularProgressIndicator());

  void dispose() {
    _controller.dispose();
    _timer?.cancel();
  }
}
