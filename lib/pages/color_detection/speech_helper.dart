// import 'package:flutter_tts/flutter_tts.dart';

// final FlutterTts tts = FlutterTts();

// Future<void> speakColor(String colorName) async {
//   await tts.setLanguage("id-ID");
//   await tts.setSpeechRate(0.5);
//   await tts.speak("Warna $colorName");
// }

import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts tts = FlutterTts();

Future<void> speakColor(String colorName) async {
  await tts.setLanguage("id-ID");
  await tts.setSpeechRate(0.5);
  await tts.speak("Warna $colorName");
}
