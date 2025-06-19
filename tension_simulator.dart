// lib/core/tension_simulator.dart

import 'dart:math';

double applyTensionScore(List<Line> lines, Line newLine, double baseScore) {
  if (lines.isEmpty) return baseScore;

  final lastLine = lines.last;
  final angle1 = _getAngleBetween(lastLine.from, lastLine.to);
  final angle2 = _getAngleBetween(newLine.from, newLine.to);

  final delta = (angle1 - angle2).abs();
  final alignmentBonus = 1.0 - (delta / pi);

  return baseScore * (0.5 + 0.5 * alignmentBonus);
}

double _getAngleBetween(Nail from, Nail to) {
  final dx = to.x - from.x;
  final dy = to.y - from.y;
  return atan2(dy, dx);
}