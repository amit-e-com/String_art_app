// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final int nailCount;
  final int maxLines;
  final int neighborAvoidance;

  const SettingsScreen({
    Key? key,
    this.nailCount = 200,
    this.maxLines = 200,
    this.neighborAvoidance = 3,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int _nailCount;
  late int _maxLines;
  late int _neighborAvoidance;

  @override
  void initState() {
    super.initState();
    _nailCount = widget.nailCount;
    _maxLines = widget.maxLines;
    _neighborAvoidance = widget.neighborAvoidance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("String Art Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Number of Nails", style: TextStyle(fontSize: 18)),
            Slider(
              min: 50,
              max: 1000,
              divisions: 19,
              label: '$_nailCount',
              value: _nailCount.toDouble(),
              onChanged: (v) {
                setState(() {
                  _nailCount = v.toInt();
                });
              },
            ),
            const SizedBox(height: 20),

            const Text("Max Lines", style: TextStyle(fontSize: 18)),
            Slider(
              min: 50,
              max: 1000,
              divisions: 19,
              label: '$_maxLines',
              value: _maxLines.toDouble(),
              onChanged: (v) {
                setState(() {
                  _maxLines = v.toInt();
                });
              },
            ),
            const SizedBox(height: 20),

            const Text("Neighbor Avoidance", style: TextStyle(fontSize: 18)),
            Slider(
              min: 0,
              max: 10,
              divisions: 10,
              label: '$_neighborAvoidance',
              value: _neighborAvoidance.toDouble(),
              onChanged: (v) {
                setState(() {
                  _neighborAvoidance = v.toInt();
                });
              },
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'nail_count': _nailCount,
                  'max_lines': _maxLines,
                  'neighbor_avoidance': _neighborAvoidance,
                });
              },
              child: const Text("Apply"),
            ),
          ],
        ),
      ),
    );
  }
}