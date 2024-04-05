import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/custom_widgets/button.dart';
import 'package:one_handed_cursor/custom_widgets/cursor.dart';
import 'package:one_handed_cursor/custom_widgets/shape_detector.dart';
import 'package:one_handed_cursor/custom_widgets/touchpad.dart';
import 'package:one_handed_cursor/helper_functions/random_list.dart';
import 'package:one_handed_cursor/helper_functions/screen_helper.dart';
import 'package:one_handed_cursor/pages/home_page.dart';
import 'package:one_handed_cursor/providers/button_index_provider.dart';
import 'package:one_handed_cursor/unistroke_recogniser/unistroke_recogniser.dart';
import '../../csv/csv.dart';

const String pageId = 'right_small_1_page';

// list permutation for buttons to appear in pseudo random order
int seed = 42;
Random random = Random(seed);
RandomList randomList = RandomList(20, random);
List<int> permutedList = randomList.generate();

//
class RightSmall1Page extends ConsumerStatefulWidget {
  const RightSmall1Page({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RightSmall1PageState();
}

class _RightSmall1PageState extends ConsumerState<RightSmall1Page> {
  // variables for drawing
  Color selectedColor = Colors.transparent;
  double strokeWidth = 3;
  List<DrawingPoints> points = List<DrawingPoints>.empty(growable: true);
  double opacity = 0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;

  // cursor widget
  final cursorWidget = const CursorWidget(initialPositionX: 50);

  // variables for starting test
  bool started = false;
  bool next = false;

  //state variables
  bool isCursorDrawn = false;
  bool isTouchpadDrawn = false;
  Rect touchpadRect = Rect.zero;

  // variables for stopwatch
  final stopWatch = Stopwatch();
  final splitStopwatch = Stopwatch();

  // data to be saved
  List<String> data = [participantID, pageId];

  final List<Button> buttons = [];

  @override
  void initState() {
    super.initState();

    double pixelRatio =
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        pixelRatio;
    double height = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.height /
        pixelRatio;

    // for right hand small targets with seed 42
    generateRandomPositions(0, width / 2, 0, height / 2, 5, 0);
    generateRandomPositions(width / 2, width - 40, 0, height / 2, 5, 5);
    generateRandomPositions(0, width / 2, height / 2, height - 100, 5, 10);
    generateRandomPositions(width / 2, width, height / 2, height - 100, 5, 15);
  }

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
          pageId: pageId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cursorNotifier =
        ref.read(cursorNotifierProvider(cursorWidget).notifier);

    final currentButtonIndex = ref.watch(buttonIndexProvider(pageId));

    void splitTime() {
      splitStopwatch.stop();
      if (data.length == 2 * currentButtonIndex + 2) {
        data.add(splitStopwatch.elapsedMilliseconds.toString());
      } else {
        data[2 * currentButtonIndex + 2] =
            (int.parse(data[2 * currentButtonIndex + 2]) +
                    splitStopwatch.elapsedMilliseconds)
                .toString();
      }
      splitStopwatch.reset();
      splitStopwatch.start();
    }

    void onShapeDrawn(String shape, List<Point> points) {
      splitTime();
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

    ref.listen<int>(buttonIndexProvider(pageId), (int? prevValue, int value) {
      stopWatch.stop();
      splitStopwatch.stop();
      reset();
      int splitTime = splitStopwatch.elapsedMilliseconds;
      int overallTime = stopWatch.elapsedMilliseconds;

      if (data.length == 2 * currentButtonIndex + 2) {
        data.add("0");
      }

      if (prevValue == 0) {
        data.add(splitTime.toString());
        next = true;
      } else if (value < buttons.length) {
        data.add(splitTime.toString());
        next = true;
      } else {
        data.add(splitTime.toString());
        data.add(overallTime.toString());
        next = false;
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
                      splitStopwatch.start();
                      started = true;
                    });
                  },
                  child: const Text('Start', style: TextStyle(fontSize: 30)),
                ),
              ),
            ),
          ),
        if (started)
          if (!next)
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
              updateDx: 1,
              updateDy: 1,
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
        if (next)
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
                      splitStopwatch.reset();
                      splitStopwatch.start();
                      stopWatch.start();
                      next = false;
                    });
                  },
                  child: Text('$currentButtonIndex/20 Next',
                      style: const TextStyle(fontSize: 30)),
                ),
              ),
            ),
          ),
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
                    splitStopwatch.reset();
                    rowsCursor.add(data);
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
