// lib/screens/preview_screen.dart

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import '../core/project_saver.dart';
import '../core/svg_exporter.dart';
import '../core/exporter.dart';
import '../core/thread_algorithm.dart';
import '../core/nail_generator.dart';
import '../widgets/string_art_canvas.dart';
import '../models/nail.dart';

class PreviewScreen extends StatelessWidget {
  final String imagePath;

  const PreviewScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return _PreviewScreenStateWidget(imagePath: imagePath);
      },
    );
  }
}

class _PreviewScreenStateWidget extends StatefulWidget {
  final String imagePath;

  const _PreviewScreenStateWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<_PreviewScreenStateWidget> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<_PreviewScreenStateWidget> {
  late img.Image originalImage;
  late img.Image edgeImage;
  late List<Nail> nails;
  late List<Line> lines;

  int nailCount = 200;
  int maxLines = 200;
  int neighborAvoidance = 3;

  Future<void> _showSettingsDialog(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          nailCount: nailCount,
          maxLines: maxLines,
          neighborAvoidance: neighborAvoidance,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        nailCount = result['nail_count'];
        maxLines = result['max_lines'];
        neighborAvoidance = result['neighbor_avoidance'];
      });

      _loadAndProcessImage(widget.imagePath);
    }
  }

  Future<void> _saveProject() async {
    final project = StringArtProject(
      imagePath: widget.imagePath,
      lines: lines,
      nailCount: nailCount,
      maxLines: maxLines,
      neighborAvoidance: neighborAvoidance,
    );

    await saveProject(project, "string_art_project");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Project saved locally")),
    );
  }

  Future<void> _loadProject() async {
    final loaded = await loadProject("string_art_project");
    if (loaded == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No saved project found")),
      );
      return;
    }

    setState(() {
      nailCount = loaded.nailCount;
      maxLines = loaded.maxLines;
      neighborAvoidance = loaded.neighborAvoidance;
      lines = loaded.lines;
      nails = generateNails(nailCount, Size(300, 300));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Project loaded")),
    );
  }

  Future<void> _exportToSvg() async {
    await exportToSvg(nails, lines);
    final dir = await getApplicationDocumentsDirectory();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exported to ${dir.path}/string_art_pattern.svg")),
    );
  }

  Future<void> _loadAndProcessImage(String path) async {
    final bytes = File(path).readAsBytesSync();
    originalImage = img.decodeImage(bytes)!;

    final resized = img.copyResize(originalImage, width: 300, height: 300);
    edgeImage = applyEdgeDetection(resized);

    final canvasSize = Size(edgeImage.width.toDouble(), edgeImage.height.toDouble());
    nails = generateNails(nailCount, canvasSize);

    lines = generateThreadPattern(nails, edgeImage,
        maxLines: maxLines, neighborAvoidance: neighborAvoidance);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadAndProcessImage(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("String Art Preview"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context),
          )
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: StringArtCanvas(
            edgeImage: edgeImage,
            nails: nails,
            lines: lines,
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              await exportThreadPattern(lines);
              final dir = await getApplicationDocumentsDirectory();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text("Exported to ${dir.path}/string_art_pattern.txt")));
            },
            icon: const Icon(Icons.save),
            label: const Text("Export TXT"),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: _exportToSvg,
            icon: const Icon(Icons.file_download),
            label: const Text("Export SVG"),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: _saveProject,
            icon: const Icon(Icons.save_alt),
            label: const Text("Save Project"),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: _loadProject,
            icon: const Icon(Icons.folder_open),
            label: const Text("Load Project"),
          ),
        ],
      ),
    );
  }
}