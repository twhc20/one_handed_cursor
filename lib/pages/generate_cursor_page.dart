import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/custom_widgets/button.dart';
import 'package:one_handed_cursor/custom_widgets/cursor.dart';
import 'package:one_handed_cursor/custom_widgets/shape_detector.dart';
import 'package:one_handed_cursor/custom_widgets/touchpad.dart';
import 'package:one_handed_cursor/helper_functions/screen_helper.dart';
import 'package:one_handed_cursor/unistroke_recogniser/unistroke_recogniser.dart';

const String pageId = 'generate_cursor_page';
final buttons = [
  const Button(
    buttonId: '3',
    x: 130,
    y: 300.0,
    pageId: pageId,
  ),
];

/* 
42 right hand small targets
*/
const int seed = 82;

class GenerateCursorPage extends ConsumerStatefulWidget {
  const GenerateCursorPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GenerateCursorPageState();
}

class _GenerateCursorPageState extends ConsumerState<GenerateCursorPage> {
  Color selectedColor = Colors.transparent;
  double strokeWidth = 3;
  List<DrawingPoints> points = List<DrawingPoints>.empty(growable: true);
  double opacity = 0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;

  final cursorWidget = const CursorWidget(initialPositionX: 50);

  bool isCursorDrawn = false;
  bool isTouchpadDrawn = false;
  Rect touchpadRect = Rect.zero;

  final Random random = Random(seed);
  // final List<Button> buttons = [];

  // @override
  // void initState() {
  //   super.initState();

  //   double pixelRatio =
  //       WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
  //   double width = WidgetsBinding
  //           .instance.platformDispatcher.views.first.physicalSize.width /
  //       pixelRatio;
  //   double height = WidgetsBinding
  //           .instance.platformDispatcher.views.first.physicalSize.height /
  //       pixelRatio;

    // for right hand small targets with seed 42
    // generateRandomPositions(0, width / 2, 0, height / 2, 5, 0);
    // generateRandomPositions(width / 2, width - 40, 0, height / 2, 5, 5);
    // generateRandomPositions(0, width / 2, height / 2, height - 100, 5, 10);
    // generateRandomPositions(width / 2, width, height / 2, height - 100, 5, 15);

    // for left hand small targets with seed 6
    // generateRandomPositions(0, width / 2, 10, height / 2, 5, 0);
    // generateRandomPositions(width / 2, width - 50, 20, height / 2, 5, 5);
    // generateRandomPositions(0, width / 2, height / 2, height - 100, 5, 10);
    // generateRandomPositions(width / 2, width, height / 2, height - 100, 5, 15);

    // left hand small continuous targets with seed 28
    // generateRandomPositions(30, width - 30, 10, height / 2, 15, 0);
    // generateRandomPositions(
    //     width / 2, width - 50, height / 2, height - 100, 5, 15);

    // right hand small continuous targets with seed 82
    // generateRandomPositions(0, width - 30, 10, height / 2, 15, 0);
    // generateRandomPositions(0, width / 2 - 100, height / 2, height - 100, 5, 15);

    // for right hand large targets with seed 42
    // generateRandomPositions(0, width / 2, 0, height / 2, 5, 0);
    // generateRandomPositions(width / 2, width - 70, 0, height / 2, 5, 5);
    // generateRandomPositions(0, width / 2, height / 2, height - 100, 5, 10);
    // generateRandomPositions(
    //     width / 2, width - 30, height / 2, height - 100, 5, 15);

    // for left hand large targets with seed 6
    // generateRandomPositions(0, width / 2, 10, height / 2, 5, 0);
    // generateRandomPositions(width / 2, width - 100, 20, height / 2, 5, 5);
    // generateRandomPositions(0, width / 2, height / 2, height - 100, 5, 10);
    // generateRandomPositions(
    //     width / 2, width - 80, height / 2, height - 100, 5, 15);

    // left hand large continuous targets with seed 28
    // generateRandomPositions(0, width - 30, 10, height / 2, 15, 0);
    // generateRandomPositions(
    //     width / 2, width - 70, height / 2, height - 100, 5, 15);

    // right hand large continuous targets with seed 82
    // generateRandomPositions(0, width - 70, 10, height / 2, 15, 0);
    // generateRandomPositions(
    //     0, width / 2 - 100, height / 2, height - 100, 5, 15);
  // }

  void generateRandomPositions(double xLowerBound, double xUpperBound,
      double yLowerBound, double yUpperBound, int count, int quadrantCounter) {
    for (int i = 0; i < count; i++) {
      final double x =
          xLowerBound + random.nextDouble() * (xUpperBound - xLowerBound);
      final double y =
          yLowerBound + random.nextDouble() * (yUpperBound - yLowerBound);
      buttons.add(Button(
          buttonId: pageId + (i + quadrantCounter).toString(),
          x: x,
          y: y,
          width: 72,
          height: 72,
          pageId: pageId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cursorNotifier =
        ref.read(cursorNotifierProvider(cursorWidget).notifier);

    void onShapeDrawn(String shape, List<Point> points) {
      ScreenHelper screenHelper = ScreenHelper(context);
      Offset cursorOffset = screenHelper.getCursorOffset(shape, points);
      setState(() {
        touchpadRect = screenHelper.getTouchpadRect(shape, points);
        isCursorDrawn = true;
        isTouchpadDrawn = true;
        ref.read(canDrawProvider.notifier).state = false;
      });
      cursorNotifier.updatePosition(cursorOffset.dx, cursorOffset.dy);
    }

    void reset() {
      setState(() {
        isCursorDrawn = false;
        isTouchpadDrawn = false;
        ref.read(canDrawProvider.notifier).state = true;
      });
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
          TouchpadWidget(
              cursorPositionX: cursorNotifier.getPositionX(),
              cursorPositionY: cursorNotifier.getPositionY(),
              initialLeft: touchpadRect.left,
              initialTop: touchpadRect.top,
              initialRight:
                  MediaQuery.of(context).size.width - touchpadRect.right,
              initialBottom:
                  MediaQuery.of(context).size.height - touchpadRect.bottom,
              updateDx: 1.2,
              updateDy: 1.2,
              onTouch: (x, y) {
                cursorNotifier.updatePosition(x, y);
              },
              onTap: () {
                for (var button in buttons) {
                  if (cursorNotifier.isCursorOnButton(button)) {
                    button.onTap(ref);
                    reset();
                  }
                }
              },
              onClose: () {
                reset();
              }),
        if (isCursorDrawn) cursorWidget,
      ],
    ));
  }
}
