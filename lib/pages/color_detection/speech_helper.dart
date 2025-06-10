// import 'package:flutter_tts/flutter_tts.dart';

// final FlutterTts tts = FlutterTts();

// Future<void> speakColor(String colorName) async {
//   await tts.setLanguage("id-ID");
//   await tts.setSpeechRate(0.5);
//   await tts.speak("Warna $colorName");
// }

import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts flutterTts = FlutterTts();

Future<void> initTts() async {
  await flutterTts.setLanguage("id-ID");
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.setVolume(1.0);
  await flutterTts.setPitch(1.0);
  await flutterTts.awaitSpeakCompletion(true); // penting agar tidak overlap dengan TalkBack
}

Future<void> speakColor(String color) async {
  await flutterTts.stop(); // hentikan suara sebelumnya jika ada
  await flutterTts.speak("Warna $color");
}
