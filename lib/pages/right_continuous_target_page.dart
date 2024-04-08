import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/csv/csv.dart';
import 'package:one_handed_cursor/custom_widgets/button.dart';
import 'package:one_handed_cursor/custom_widgets/cursor.dart';
import 'package:one_handed_cursor/custom_widgets/shape_detector.dart';
import 'package:one_handed_cursor/custom_widgets/touchpad.dart';
import 'package:one_handed_cursor/helper_functions/random_list.dart';
import 'package:one_handed_cursor/helper_functions/screen_helper.dart';
import 'package:one_handed_cursor/pages/home_page.dart';
import 'package:one_handed_cursor/providers/button_index_provider.dart';
import 'package:one_handed_cursor/unistroke_recogniser/unistroke_recogniser.dart';

// list permutation for buttons to appear in pseudo random order
int seed = 82;
Random random = Random(seed);
RandomList randomList = RandomList(20, random);
List<int> permutedList = randomList.generate();

//
class RightContinuousTargetPage extends ConsumerStatefulWidget {
  final double targetSize;
  final double cdGain;

  const RightContinuousTargetPage(this.targetSize, this.cdGain, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RightContinuousTargetPageState();
}

class _RightContinuousTargetPageState
    extends ConsumerState<RightContinuousTargetPage> {
  String pageId = 'right_continuous_target_page';
  double targetSize = 0;
  double cdGain = 0;

  // variables for drawing
  Color selectedColor = Colors.transparent;
  double strokeWidth = 3;
  List<DrawingPoints> points = List<DrawingPoints>.empty(growable: true);
  double opacity = 0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;

  // cursor widget
  final cursorWidget = const CursorWidget(initialPositionX: 50);

  //state variables
  bool isCursorDrawn = false;
  bool isTouchpadDrawn = false;
  Rect touchpadRect = Rect.zero;

  // variables for starting test
  bool started = false;

  // variables for stopwatch
  final stopWatch = Stopwatch();

  // data to be saved
  List<String> data = [participantID];

  final List<Button> buttons = [];

  @override
  void initState() {
    super.initState();

    targetSize = widget.targetSize;
    String targetSizeString = targetSize == 42 ? 'small' : 'large';
    cdGain = widget.cdGain;
    pageId = "cd:${cdGain}_targeSize:${targetSizeString}_$pageId";
    data.add(pageId);

    double pixelRatio =
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        pixelRatio;
    double height = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.height /
        pixelRatio;

    if (targetSize == 42) {
      // right hand small continuous targets with seed 82
      generateRandomPositions(0, width - 30, 10, height / 2, 15, 0, targetSize);
      generateRandomPositions(
          0, width / 2 - 100, height / 2, height - 100, 5, 15, targetSize);
    } else if (targetSize == 72) {
      // right hand large continuous targets with seed 82
      generateRandomPositions(0, width - 70, 10, height / 2, 15, 0, targetSize);
      generateRandomPositions(
          0, width / 2 - 100, height / 2, height - 100, 5, 15, targetSize);
    }
  }

  void generateRandomPositions(
      double xLowerBound,
      double xUpperBound,
      double yLowerBound,
      double yUpperBound,
      int count,
      int quadrantCounter,
      double targetSize) {
    for (int i = 0; i < count; i++) {
      final double x =
          xLowerBound + random.nextDouble() * (xUpperBound - xLowerBound);
      final double y =
          yLowerBound + random.nextDouble() * (yUpperBound - yLowerBound);
      buttons.add(Button(
          buttonId: pageId + (i + quadrantCounter).toString(),
          x: x,
          y: y,
          width: targetSize,
          height: targetSize,
          pageId: pageId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cursorNotifier =
        ref.read(cursorNotifierProvider(cursorWidget).notifier);

    final currentButtonIndex = ref.watch(buttonIndexProvider(pageId));

    void onShapeDrawn(String shape, List<Point> points) {
      ScreenHelper screenHelper = ScreenHelper(context);
      Offset cursorOffset = screenHelper.getCursorOffset(shape, points);
      double centerX = screenHelper.getCenterX(shape, points);
      double centerY = screenHelper.getCenterY(shape, points);
      double width = screenHelper.getWidth(shape, points);
      double height = screenHelper.getHeight(shape, points);
      double area = screenHelper.getArea(shape, points);
      List<String> shapeDataLocal = [
        participantID,
        pageId,
        shape,
        centerX.toString(),
        centerY.toString(),
        width.toString(),
        height.toString(),
        area.toString()
      ];
      shapeData.add(shapeDataLocal);
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

    ref.listen<int>(buttonIndexProvider(pageId), (int? prevValue, int value) {
      if (value == 20) {
        setState(() {
          reset();
        });
        stopWatch.stop();
        data.add(stopWatch.elapsedMilliseconds.toString());
      }
    });

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
        if (!started)
          Positioned(
            left: 0,
            right: 0,
            bottom: 65,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 250,
                height: 150,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      stopWatch.start();
                      started = true;
                    });
                  },
                  child: const Text('Start', style: TextStyle(fontSize: 30)),
                ),
              ),
            ),
          ),
        if (started)
          if (currentButtonIndex < buttons.length)
            buttons[permutedList[currentButtonIndex]],
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
              updateDx: cdGain,
              updateDy: cdGain,
              onTouch: (x, y) {
                cursorNotifier.updatePosition(x, y);
              },
              onTap: () {
                for (var button in buttons) {
                  if (button == buttons[permutedList[currentButtonIndex]] &&
                      cursorNotifier.isCursorOnButton(button)) {
                    button.onTap(ref);
                  }
                }
              },
              onClose: () {
                reset();
              }, onSwipe: (double ) {  },),
        if (isCursorDrawn) cursorWidget,
        if (currentButtonIndex == buttons.length)
          Positioned(
            left: 0,
            right: 0,
            bottom: 65,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 250,
                height: 150,
                child: ElevatedButton(
                  onPressed: () {
                    stopWatch.reset();
                    continuousRowsCursor.add(data);
                    Navigator.pop(context);
                  },
                  child: const Text('Finished', style: TextStyle(fontSize: 30)),
                ),
              ),
            ),
          ),
      ],
    ));
  }
}
