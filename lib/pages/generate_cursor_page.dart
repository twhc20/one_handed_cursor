import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/custom_widgets/button.dart';
import 'package:one_handed_cursor/custom_widgets/cursor.dart';
import 'package:one_handed_cursor/custom_widgets/shape_detector.dart';
import 'package:one_handed_cursor/custom_widgets/touchpad.dart';
import 'package:one_handed_cursor/helper_functions/screen_helper.dart';
import 'package:one_handed_cursor/unistroke_recogniser/unistroke_recogniser.dart';

final buttons = [
  const Button(id: '3', x: 130, y: 300.0),
];

class GenerateCursorPage extends ConsumerStatefulWidget {
  const GenerateCursorPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GenerateCursorPageState();
}

class _GenerateCursorPageState extends ConsumerState<GenerateCursorPage> {
  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = List<DrawingPoints>.empty(growable: true);
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;

  final cursorWidget = const CursorWidget(initialPositionX: 50);

  bool isCursorDrawn = false;
  bool isTouchpadDrawn = false;

  @override
  Widget build(BuildContext context) {
    final cursorNotifier =
        ref.read(cursorNotifierProvider(cursorWidget).notifier);

    void onShapeDrawn(String shape, List<Point> points) {
      ScreenHelper screenHelper = ScreenHelper(context);
      Offset cursorOffset = screenHelper.getCursorOffset(shape, points);
      // Rect touchpadRect = screenHelper.getTouchpadRect(shape, points);
      setState(() {
        isCursorDrawn = true;
      });
      cursorNotifier.updatePosition(cursorOffset.dx, cursorOffset.dy);
    }

    return Scaffold(
        body: Stack(
      children: [
        ShapeDetector(
            selectedColor: selectedColor,
            strokeWidth: strokeWidth,
            points: points,
            opacity: opacity,
            strokeCap: strokeCap,
            onShapeDrawn: (String shape, List<Point> points) =>
                onShapeDrawn(shape, points)),
        ...buttons,
        if (isTouchpadDrawn)
          Touchpad(onUpdatePosition: (double x, double y) {
            cursorNotifier.updatePosition(x, y);
          }, onTap: () {
            for (var button in buttons) {
              if (cursorNotifier.isCursorOnButton(button)) {
                button.onTap(ref);
              }
            }
          }),
        if (isCursorDrawn) cursorWidget,
      ],
    ));
  }
}
