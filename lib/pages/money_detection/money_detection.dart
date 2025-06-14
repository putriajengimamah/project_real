import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MoneyDetectionPage extends StatefulWidget {
  // Menambahkan Key agar sesuai dengan best practice Dart (mengatasi Error #4)
  const MoneyDetectionPage({super.key});

  @override
  State<MoneyDetectionPage> createState() => _MoneyDetectionPageState();
}

class _MoneyDetectionPageState extends State<MoneyDetectionPage> {
  final ImagePicker _picker = ImagePicker();
  final FlutterTts _flutterTts = FlutterTts();
  final Dio _dio = Dio();

  File? _imageFile;
  String _resultText = "Silakan pilih gambar untuk dideteksi";
  bool _isLoading = false;

  // GANTI DENGAN IP ADDRESS LOKAL KOMPUTER ANDA
  // final String _apiUrl = "http://192.168.1.4:8000/predict";
  final String _apiUrl = "http://192.168.48.123:8000/predict";

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    // Pengaturan untuk Text-to-Speech
    await _flutterTts.setLanguage("id-ID");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _pickAndPredictImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      setState(() {
        _imageFile = File(pickedFile.path);
        _isLoading = true;
        _resultText = "Menganalisis gambar...";
      });

      // Siapkan data gambar untuk dikirim
      String fileName = _imageFile!.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image_file": await MultipartFile.fromFile(_imageFile!.path, filename: fileName),
      });
      
      // Kirim ke API Server Lokal
      final response = await _dio.post(_apiUrl, data: formData);
      
      // Proses respons dari server
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final nominal = response.data['nominal'];
        setState(() {
          _resultText = "Nominal yang terdeteksi: Rp $nominal";
        });
      } else {
        setState(() {
          _resultText = response.data['message'] ?? "Gagal mendeteksi nominal.";
        });
      }

    } catch (e) {
      // Handle error jaringan atau server tidak aktif
      setState(() {
        _resultText = "Error: Tidak dapat terhubung ke server. Pastikan server lokal berjalan dan Anda terhubung ke WiFi yang sama.";
      });
      print("Dio Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
      // Bacakan hasilnya
      _flutterTts.speak(_resultText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deteksi Nominal Uang"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Area untuk menampilkan gambar
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_imageFile!, fit: BoxFit.cover),
                      )
                    : const Center(
                        child: Icon(Icons.image, size: 80, color: Colors.grey),
                      ),
              ),
              const SizedBox(height: 24),
              
              // Tombol-tombol
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _pickAndPredictImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Kamera"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _pickAndPredictImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Galeri"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Area untuk menampilkan hasil
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          _resultText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}