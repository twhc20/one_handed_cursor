import 'dart:io';

import 'package:flutter/material.dart';
import 'package:one_handed_cursor/custom_widgets/old_shape_detector.dart';
import 'package:one_handed_cursor/custom_widgets/shape_detector.dart';
import 'package:one_handed_cursor/unistroke_recogniser/gestures_templates.dart';
import 'package:one_handed_cursor/unistroke_recogniser/unistroke_recogniser.dart';

var recognizer = DollarRecognizer.withGestures(getTemplates());
late List<Point> pointsToRecognize;

class GestureDetectorPage extends StatefulWidget {
  const GestureDetectorPage({super.key});

  @override
  State<GestureDetectorPage> createState() => _GestureDetectorPageState();
}

class _GestureDetectorPageState extends State<GestureDetectorPage> {
  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = List<DrawingPoints>.empty(growable: true);
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OldShapeDetector(
            selectedColor: selectedColor,
            strokeWidth: strokeWidth,
            points: points,
            opacity: opacity,
            strokeCap: strokeCap));
  }
}
