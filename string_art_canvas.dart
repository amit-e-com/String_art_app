// lib/widgets/string_art_canvas.dart

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../models/nail.dart';
import '../models/line.dart';

class StringArtCanvas extends StatelessWidget {
  final img.Image edgeImage;
  final List<Nail> nails;
  final List<Line> lines;

  const StringArtCanvas({
    Key? key,
    required this.edgeImage,
    required this.nails,
    required this.lines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(edgeImage.width.toDouble(), edgeImage.height.toDouble()),
      painter: StringArtPainter(nails, lines),
    );
  }
}

class StringArtPainter extends CustomPainter {
  final List<Nail> nails;
  final List<Line> lines;

  StringArtPainter(this.nails, this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    final nailPaint = Paint()
      ..color = Colors.red.withOpacity(0.4)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    for (var nail in nails) {
      canvas.drawCircle(Offset(nail.x, nail.y), 2.0, nailPaint);
    }

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke
      ..blendMode = BlendMode.darken;

    for (var line in lines) {
      canvas.drawLine(
        Offset(line.from.x, line.from.y),
        Offset(line.to.x, line.to.y),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}