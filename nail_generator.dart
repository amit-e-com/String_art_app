// lib/core/nail_generator.dart

import 'dart:math';
import '../models/nail.dart';

List<Nail> generateNails(int count, Size canvasSize) {
  final centerX = canvasSize.width / 2;
  final centerY = canvasSize.height / 2;
  final radius = min(centerX, centerY) * 0.9;

  final nails = <Nail>[];
  for (int i = 0; i < count; i++) {
    final angle = 2 * pi * i / count;
    final x = centerX + radius * cos(angle);
    final y = centerY + radius * sin(angle);
    nails.add(Nail(i, x, y));
  }

  return nails;
}