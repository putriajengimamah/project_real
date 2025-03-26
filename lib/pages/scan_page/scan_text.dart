import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ScanText extends StatefulWidget {
  @override
  _ScanTextState createState() => _ScanTextState();
}

class _ScanTextState extends State<ScanText> {
  File? _image;
  String _extractedText = "";
  final FlutterTts flutterTts = FlutterTts();
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = (connectivityResult != ConnectivityResult.none);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _extractedText = "";
      });
      _isOnline ? await _scanTextOnline() : await _scanTextOffline();
    }
  }

  Future<void> _scanTextOnline() async {
    try {
      String apiUrl = "http://192.168.1.2:5000/scan-text";
      FormData formData = FormData.fromMap({"image": await MultipartFile.fromFile(_image!.path)});
      Response response = await Dio().post(apiUrl, data: formData);
      setState(() {
        _extractedText = response.data["text"];
      });
    } catch (e) {
      setState(() {
        _isOnline = false;
      });
      await _scanTextOffline();
    }
  }

  Future<void> _scanTextOffline() async {
    final inputImage = InputImage.fromFile(_image!);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();
    setState(() {
      _extractedText = recognizedText.text;
    });
  }

  void _speakText() async => await flutterTts.speak(_extractedText);
  void _stopSpeaking() async => await flutterTts.stop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Text")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera_alt),
                  label: Text("Camera"),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.photo_library),
                  label: Text("Gallery"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _extractedText.isEmpty ? "No text detected" : _extractedText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            if (_extractedText.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: Icon(Icons.volume_up), onPressed: _speakText),
                  IconButton(icon: Icon(Icons.stop), onPressed: _stopSpeaking),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}