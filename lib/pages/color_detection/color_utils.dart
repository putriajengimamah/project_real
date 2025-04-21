// import 'dart:math';
// import 'package:flutter/material.dart';

// String getColorNameFromRGB(int r, int g, int b) {
//   final namedColors = {
//     'Merah': const Color.fromARGB(255, 255, 0, 0),
//     'Hijau': const Color.fromARGB(255, 0, 255, 0),
//     'Biru': const Color.fromARGB(255, 0, 0, 255),
//     'Kuning': const Color.fromARGB(255, 255, 255, 0),
//     'Hitam': const Color.fromARGB(255, 0, 0, 0),
//     'Putih': const Color.fromARGB(255, 255, 255, 255),
//     'Abu-Abu': const Color.fromARGB(255, 128, 128, 128),
//     'Coklat': const Color.fromARGB(255, 165, 42, 42),
//     'Oranye': const Color.fromARGB(255, 255, 165, 0),
//     'Ungu': const Color.fromARGB(255, 128, 0, 128),
//   };

//   double minDistance = double.infinity;
//   String closestColor = 'Tidak Dikenali';

//   namedColors.forEach((name, color) {
//     final dr = (color.r - r).abs();
//     final dg = (color.g - g).abs();
//     final db = (color.b - b).abs();
//     final distance = sqrt(dr * dr + dg * dg + db * db);
//     if (distance < minDistance) {
//       minDistance = distance;
//       closestColor = name;
//     }
//   });

//   return closestColor;
// }


import 'dart:math';
import 'package:flutter/material.dart';

String getColorNameFromRGB(int r, int g, int b) {
  final namedColors = {
    'Merah': const Color.fromARGB(255, 255, 0, 0),
    'Hijau': const Color.fromARGB(255, 0, 255, 0),
    'Biru': const Color.fromARGB(255, 0, 0, 255),
    'Kuning': const Color.fromARGB(255, 255, 255, 0),
    'Hitam': const Color.fromARGB(255, 0, 0, 0),
    'Putih': const Color.fromARGB(255, 255, 255, 255),
    'Abu-Abu': const Color.fromARGB(255, 128, 128, 128),
    'Coklat': const Color.fromARGB(255, 165, 42, 42),
    'Oranye': const Color.fromARGB(255, 255, 165, 0),
    'Ungu': const Color.fromARGB(255, 128, 0, 128),
  };

  double minDistance = double.infinity;
  String closestColor = 'Tidak Dikenali';

  namedColors.forEach((name, color) {
    final dr = (color.r - r).abs();
    final dg = (color.g - g).abs();
    final db = (color.b - b).abs();
    final distance = sqrt(dr * dr + dg * dg + db * db);
    if (distance < minDistance) {
      minDistance = distance;
      closestColor = name;
    }
  });

  return closestColor;
}
