import 'dart:io';

import 'package:flutter/material.dart';
import 'package:one_handed_cursor/custom_widgets/shape_detector.dart';
import 'package:one_handed_cursor/unistroke_recogniser/gestures_templates.dart';
import 'package:one_handed_cursor/unistroke_recogniser/unistroke_recogniser.dart';

var recognizer = DollarRecognizer.withGestures(getTemplates());
late List<Point> pointsToRecognize;

class Draw extends StatefulWidget {
  const Draw({super.key});

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = List<DrawingPoints>.empty(growable: true);
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ShapeDetector(
            selectedColor: selectedColor,
            strokeWidth: strokeWidth,
            points: points,
            opacity: opacity,
            strokeCap: strokeCap));
  }
}