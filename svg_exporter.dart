// lib/core/svg_exporter.dart

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/line.dart';
import '../models/nail.dart';

Future<void> exportToSvg(List<Nail> nails, List<Line> lines, {int size = 300}) async {
  final buffer = StringBuffer();

  buffer.writeln('<?xml version="1.0" encoding="UTF-8" standalone="no"?>');
  buffer.writeln('<svg width="$size" height="$size" viewBox="0 0 $size $size" xmlns="http://www.w3.org/2000/svg">');

  for (var nail in nails) {
    buffer.writeln('<circle cx="${nail.x}" cy="${nail.y}" r="2" fill="red" opacity="0.6"/>');
  }

  for (var line in lines) {
    buffer.writeln('<line x1="${line.from.x}" y1="${line.from.y}" x2="${line.to.x}" y2="${line.to.y}" stroke="white" stroke-width="0.5" opacity="0.8"/>');
  }

  buffer.writeln('</svg>');

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/string_art_pattern.svg');
  await file.writeAsString(buffer.toString());
}