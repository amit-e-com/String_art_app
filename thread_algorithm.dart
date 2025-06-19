// lib/core/thread_algorithm.dart

import 'dart:math';
import 'package:image/image.dart' as img;
import '../models/nail.dart';
import '../models/line.dart';
import '../tension_simulator.dart';

double calculateLineScore(Nail from, Nail to, img.Image edgeImage) {
  final dx = to.x - from.x;
  final dy = to.y - from.y;
  final length = sqrt(dx * dx + dy * dy);

  if (length < 5) return 0;

  double score = 0;
  final steps = min(length.toInt(), 20);

  for (int t = 0; t < steps; t++) {
    final x = from.x + dx * t / steps;
    final y = from.y + dy * t / steps;

    final px = x.toInt().clamp(0, edgeImage.width - 1);
    final py = y.toInt().clamp(0, edgeImage.height - 1);

    final pixel = edgeImage.getPixel(px, py);
    final intensity = img.getRed(pixel);
    score += intensity;
  }

  return score / steps;
}

bool areNeighbors(int a, int b, int totalNails) {
  final diff = (a - b).abs();
  return diff == 1 || diff == totalNails - 1;
}

List<Line> generateThreadPattern(
    List<Nail> nails, img.Image edgeImage,
    {int maxLines = 200, int neighborAvoidance = 3}) {
  final lines = <Line>[];
  final usedConnections = <String>{};
  var currentNailIndex = 0;

  for (int i = 0; i < maxLines; i++) {
    double bestScore = -1;
    int bestNailIndex = -1;

    for (int j = 0; j < nails.length; j++) {
      if (j == currentNailIndex) continue;

      final diff = (currentNailIndex - j).abs();
      if (diff <= neighborAvoidance && diff != 0) continue;

      final key = "${min(currentNailIndex, j)}-${max(currentNailIndex, j)}";
      if (usedConnections.contains(key)) continue;

      final score = calculateLineScore(nails[currentNailIndex], nails[j], edgeImage);
      final tensionScore = applyTensionScore(lines, Line(nails[currentNailIndex], nails[j]), score);

      if (tensionScore > bestScore) {
        bestScore = tensionScore;
        bestNailIndex = j;
      }
    }

    if (bestNailIndex == -1) break;

    lines.add(Line(nails[currentNailIndex], nails[bestNailIndex]));
    usedConnections.add("${min(currentNailIndex, bestNailIndex)}-${max(currentNailIndex, bestNailIndex)}");
    currentNailIndex = bestNailIndex;
  }

  return lines;
}