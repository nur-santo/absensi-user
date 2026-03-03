import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'face_camera_page.dart';
import 'face_embedding.dart';
import '../services/wajah_service.dart';

class FaceCapturePage extends StatefulWidget {
  const FaceCapturePage({super.key});

  @override
  State<FaceCapturePage> createState() => _FaceCapturePageState();
}

class _FaceCapturePageState extends State<FaceCapturePage> {
  bool _processing = false;

  @override
  Widget build(BuildContext context) {
    return FaceCameraPage(
      onCapture: (file) async {
        if (_processing) return;
        _processing = true;

        try {
          // Load TFLite model
          await FaceEmbedding.loadModel();

          // Decode image dan generate embedding
          final bytes = await File(file.path).readAsBytes();
          final image = img.decodeImage(bytes)!;
          final embedding = FaceEmbedding.generate(image);

          // Simpan embedding
          await WajahService.store(embedding);

          // Navigasi aman
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/');
        } catch (e) {
          debugPrint('Error saat capture wajah: $e');
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal capture wajah')),
          );
        } finally {
          _processing = false;
        }
      },
    );
  }
}
