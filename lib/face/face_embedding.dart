import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class FaceEmbedding {
  static Interpreter? _interpreter;

  static Future<void> loadModel() async {
    if (_interpreter != null) return;

    _interpreter = await Interpreter.fromAsset(
      'assets/mobilefacenet.tflite',
      options: InterpreterOptions()..threads = 4,
    );

    // Debug (aman karena interpreter sudah ada)
    final inputTensor = _interpreter!.getInputTensor(0);
    final outputTensor = _interpreter!.getOutputTensor(0);

    print('Input shape  : ${inputTensor.shape}');
    print('Output shape : ${outputTensor.shape}');
  }

  static Float32List generate(img.Image image) {
    if (_interpreter == null) {
      throw StateError('TFLite model not loaded. Call loadModel() first.');
    }

    final input = _preprocess(image).reshape([1, 112, 112, 3]);
    final output = List.filled(1 * 192, 0.0).reshape([1, 192]);

    _interpreter!.run(input, output);

    return Float32List.fromList(output[0]);
  }

  /// Output shape: [1, 112, 112, 3]
  static Float32List _preprocess(img.Image image) {
    final resized = img.copyResize(image, width: 112, height: 112);

    final input = Float32List(1 * 112 * 112 * 3);
    int index = 0;

    for (int y = 0; y < 112; y++) {
      for (int x = 0; x < 112; x++) {
        final pixel = resized.getPixel(x, y);

        input[index++] = (pixel.r - 127.5) / 128;
        input[index++] = (pixel.g - 127.5) / 128;
        input[index++] = (pixel.b - 127.5) / 128;
      }
    }

    return input;
  }
}
