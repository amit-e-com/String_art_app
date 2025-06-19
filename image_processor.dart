// lib/core/image_processor.dart

import 'package:image/image.dart' as img;

img.Image applyEdgeDetection(img.Image image) {
  final kernelX = [
    [-1, 0, 1],
    [-2, 0, 2],
    [-1, 0, 1],
  ];

  final kernelY = [
    [-1, -2, -1],
    [0, 0, 0],
    [1, 2, 1],
  ];

  final output = img.Image.from(image.width, image.height);

  for (int y = 1; y < image.height - 1; y++) {
    for (int x = 1; x < image.width - 1; x++) {
      int gx = 0, gy = 0;

      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          final pixel = image.getPixel(x + kx, y + ky);
          final intensity = img.getRed(pixel); // Grayscale assumed

          gx += intensity * kernelX[ky + 1][kx + 1];
          gy += intensity * kernelY[ky + 1][kx + 1];
        }
      }

      final magnitude = (gx.abs() + gy.abs()).clamp(0, 255);
      final color = img.ColorRgb8(magnitude, magnitude, magnitude);
      output.setPixel(x, y, color);
    }
  }

  return output;
}