// lib/core/project_saver.dart

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import '../models/line.dart';

class StringArtProject {
  final String imagePath;
  final List<Line> lines;
  final int nailCount;
  final int maxLines;
  final int neighborAvoidance;

  StringArtProject({
    required this.imagePath,
    required this.lines,
    required this.nailCount,
    required this.maxLines,
    required this.neighborAvoidance,
  });

  Map<String, dynamic> toJson() {
    return {
      'image_path': imagePath,
      'nail_count': nailCount,
      'max_lines': maxLines,
      'neighbor_avoidance': neighborAvoidance,
      'lines': lines.map((line) => [line.from.id, line.to.id]).toList(),
    };
  }

  static StringArtProject fromJson(Map<String, dynamic> map, String imagePath) {
    final lines = (map['lines'] as List)
        .map((pair) => Line(
              Nail(pair[0], 0, 0),
              Nail(pair[1], 0, 0),
            ))
        .toList();

    return StringArtProject(
      imagePath: imagePath,
      lines: lines,
      nailCount: map['nail_count'],
      maxLines: map['max_lines'],
      neighborAvoidance: map['neighbor_avoidance'],
    );
  }
}

Future<void> saveProject(StringArtProject project, String fileName) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$fileName.json');

  final json = jsonEncode(project.toJson());
  await file.writeAsString(json);
}

Future<StringArtProject?> loadProject(String fileName) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$fileName.json');

  if (!file.existsSync()) return null;

  final content = file.readAsStringSync();
  final map = jsonDecode(content);

  return StringArtProject.fromJson(map, map['image_path']);
}