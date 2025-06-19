// lib/core/exporter.dart

import '../models/line.dart';

String exportToText(List<Line> lines) {
  final buffer = StringBuffer();
  for (int i = 0; i < lines.length; i++) {
    buffer.writeln("Line (${i + 1}), thread point from (${lines[i].from.id + 1}) to (${lines[i].to.id + 1})");
  }
  return buffer.toString();
}