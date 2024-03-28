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

const String pageId = 'right_big_1.5_continuous_page';
// List of buttons
// Each button has an id, x, y, width, height
final buttons = [
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous1',
      x: 30,
      y: 34,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous2',
      x: 145,
      y: 86,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous3',
      x: 87,
      y: 237,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous4',
      x: 133,
      y: 152,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous5',
      x: 54,
      y: 286,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous6',
      x: 230,
      y: 56,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous7',
      x: 264,
      y: 90,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous8',
      x: 290,
      y: 384,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous9',
      x: 297,
      y: 230,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous10',
      x: 370,
      y: 130,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous11',
      x: 35,
      y: 199,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous12',
      x: 99,
      y: 143,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous13',
      x: 43,
      y: 330,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous14',
      x: 157,
      y: 399,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous15',
      x: 115,
      y: 470,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous16',
      x: 256,
      y: 283,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous17',
      x: 287,
      y: 444,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous18',
      x: 301,
      y: 301,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous19',
      x: 275,
      y: 343,
      pageId: pageId),
  const Button(
      width: 67.5,
      height: 67.5,
      buttonId: 'continuous20',
      x: 336,
      y: 470,
      pageId: pageId),
];

// list permutation for buttons to appear in pseudo random order
int seed = 53;
Random random = Random(seed);
RandomList randomList = RandomList(20, random);
List<int> permutedList = randomList.generate();

//
class RightBig15ContinuousPage extends ConsumerStatefulWidget {
  const RightBig15ContinuousPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RightBig15ContinuousPageState();
}

class _RightBig15ContinuousPageState
    extends ConsumerState<RightBig15ContinuousPage> {
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
  List<String> data = [participantId, pageId];

  @override
  Widget build(BuildContext context) {
    final cursorNotifier =
        ref.read(cursorNotifierProvider(cursorWidget).notifier);

    final currentButtonIndex = ref.watch(buttonIndexProvider(pageId));

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
              updateDx: 1.5,
              updateDy: 1.5,
              onTouch: (x, y) {
                cursorNotifier.updatePosition(x, y);
              },
              onTap: () {
                for (var button in buttons) {
                  if (cursorNotifier.isCursorOnButton(button)) {
                    button.onTap(ref);
                  }
                }
              },
              onClose: () {
                reset();
              }),
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
