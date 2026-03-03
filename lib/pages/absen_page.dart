import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../face/face_camera_page.dart';
import '../face/face_embedding.dart';
import '../services/kehadiran_service.dart';

class AbsenPage extends StatefulWidget {
  const AbsenPage({super.key});

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
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

          // Decode image & generate embedding
          final bytes = await File(file.path).readAsBytes();
          final image = img.decodeImage(bytes)!;
          final embedding = FaceEmbedding.generate(image);

          // Simpan data absen
          await KehadiranService.absenMasuk(embedding);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Absen berhasil')),
          );

          Navigator.pop(context);
        } catch (e) {
          debugPrint('Error saat absen: $e');

          final message = e.toString().replaceFirst('Exception: ', '');

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        } finally {
          _processing = false;
        }
      },
    );
  }
}
