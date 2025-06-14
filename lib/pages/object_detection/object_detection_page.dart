// File: lib/pages/object_detection/object_detection.dart
// Versi ini berisi perbaikan untuk Null Pointer Exception saat menggambar hasil.

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_vision/flutter_vision.dart';

class ObjectDetectionPage extends StatefulWidget {
  const ObjectDetectionPage({super.key});

  @override
  State<ObjectDetectionPage> createState() => _ObjectDetectionPageState();
}

class _ObjectDetectionPageState extends State<ObjectDetectionPage> {
  late FlutterVision vision;
  CameraController? cameraController;
  List<Map<String, dynamic>> yoloResults = [];
  bool isLoading = true;
  bool isDetecting = false;
  String? targetObject;
  bool targetFoundAndSpoken = false;
  int stableDetectionCounter = 0;
  final int requiredStableFrames = 3; 

  int frameCounter = 0;

  final FlutterTts flutterTts = FlutterTts();
  final List<String> searchableObjects = [
    'chair', 'cupboard', 'laptop', 'wallet', 'tumbler'
  ];

  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
    _initializeApp();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    vision.closeYoloModel();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await _initTts();
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      _showError("Tidak ada kamera yang tersedia di perangkat ini.");
      return;
    }

    cameraController = CameraController(cameras[0], ResolutionPreset.low, enableAudio: false);
    
    try {
      await cameraController!.initialize();
      await _loadYoloModel();
    } catch (e) {
      _showError("Gagal memulai kamera atau memuat model AI.");
      print("Error inisialisasi: $e");
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> _loadYoloModel() async {
    try {
      await vision.loadYoloModel(
          labels: 'assets/models/labels.txt',
          modelPath: 'assets/models/best_int8.tflite',
          modelVersion: "yolov8",
          quantization: true,
          numThreads: 1,
          useGpu: false);
      print("Model deteksi objek berhasil dimuat.");
    } catch (e) {
      print("Error saat memuat model deteksi objek: $e");
      _showError("Gagal memuat model AI.");
    }
  }

  void _startDetectionStream() {
    if (cameraController?.value.isStreamingImages ?? false) return;
    
    isDetecting = false; 
    cameraController?.startImageStream((image) {
      frameCounter++;
      if (frameCounter % 5 != 0) return; 

      if (isDetecting) return;

      isDetecting = true;
      vision.yoloOnFrame(
          bytesList: image.planes.map((plane) => plane.bytes).toList(),
          imageHeight: image.height,
          imageWidth: image.width,
          iouThreshold: 0.4,
          confThreshold: 0.25,
          classThreshold: 0.25)
      .then((result) {
        if (mounted) {
          setState(() {
            yoloResults = result;
          });
          if (targetObject != null) {
            _processDetections(targetObject!);
          }
        }
      }).whenComplete(() => isDetecting = false);
    });
  }

  void _stopDetectionStream() {
    if (cameraController?.value.isStreamingImages ?? false) {
      cameraController?.stopImageStream();
    }
  }

  void _processDetections(String currentTarget) {
    bool foundInThisFrame = yoloResults.any((result) => result['tag'] == currentTarget);

    if (foundInThisFrame) {
      stableDetectionCounter++;
      if (stableDetectionCounter >= requiredStableFrames && !targetFoundAndSpoken) { 
        flutterTts.speak('$currentTarget terdeteksi');
        targetFoundAndSpoken = true;
      }
    } else {
      stableDetectionCounter = 0;
      targetFoundAndSpoken = false;
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || cameraController == null || !cameraController!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    final size = MediaQuery.of(context).size;
    final cameraAspectRatio = cameraController!.value.aspectRatio;
    var scale = size.aspectRatio * cameraAspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Scaffold(
      appBar: AppBar(title: const Text("Cari Objek (Mode Debug)"), backgroundColor: Colors.blueAccent),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scale: scale,
            child: Center(child: CameraPreview(cameraController!)),
          ),
          ..._displayBoxes(size),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                alignment: WrapAlignment.center,
                children: searchableObjects.map((object) {
                  bool isSelected = targetObject == object;
                  return ChoiceChip(
                    label: Text(object, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          targetObject = object;
                          flutterTts.speak("Mencari $object");
                          _startDetectionStream();
                        } else {
                          targetObject = null;
                          _stopDetectionStream();
                          flutterTts.speak("Pencarian dihentikan");
                        }
                        yoloResults.clear();
                        stableDetectionCounter = 0;
                        targetFoundAndSpoken = false;
                      });
                    },
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // --- PERBAIKAN UNTUK MENCEGAH CRASH SAAT MENAMPILKAN HASIL ---
  List<Widget> _displayBoxes(Size screen) {
    if (yoloResults.isEmpty) return [];

    return yoloResults.map((result) {
      // Safety Check: Pastikan nilai confidence tidak null. Jika null, anggap 0.
      final double confidence = result['confidenceInClass'] as double? ?? 0.0;

      final color = result['tag'] == targetObject ? Colors.greenAccent : Colors.pink;

      return Positioned(
        left: result["box"][0] * screen.width,
        top: result["box"][1] * screen.height,
        width: (result["box"][2] - result["box"][0]) * screen.width,
        height: (result["box"][3] - result["box"][1]) * screen.height,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(color: color, width: 3.0),
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: color,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Text(
                // Gunakan variabel 'confidence' yang sudah aman
                "${result['tag']} ${(confidence * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}