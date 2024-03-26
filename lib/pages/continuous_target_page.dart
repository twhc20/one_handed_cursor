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
import 'package:one_handed_cursor/providers/button_index_provider.dart';
import 'package:one_handed_cursor/unistroke_recogniser/unistroke_recogniser.dart';


const String pageId = 'continuous_target_page';
// List of buttons
// Each button has an id, x, y, width, height
final buttons = [
  const Button(buttonId: '4', x: 10, y: 10, width: 50, height: 50, pageId: pageId),
  const Button(buttonId: '5', x: 70, y: 10, width: 50, height: 50, pageId: pageId),
  const Button(buttonId: '6', x: 130, y: 10, width: 50, height: 50, pageId: pageId),
  const Button(buttonId: '7', x: 190, y: 10, width: 50, height: 50, pageId: pageId),
  const Button(buttonId: '8', x: 10, y: 70, width: 50, height: 50, pageId: pageId),
  const Button(buttonId: '9', x: 70, y: 70, width: 50, height: 50, pageId: pageId),
  const Button(buttonId: '10', x: 130, y: 70, width: 50, height: 50, pageId: pageId),
  const Button(buttonId: '11', x: 190, y: 70, width: 50, height: 50, pageId: pageId),
  const Button(buttonId: '12', x: 10, y: 130, width: 50, height: 50, pageId: pageId),
  const Button(buttonId: '13', x: 70, y: 130, width: 50, height: 50, pageId: pageId),
  const Button(buttonId: '14', x: 130, y: 130, width: 50, height: 50, pageId:pageId),
  const Button(buttonId: '15', x: 190, y: 130, width: 50, height: 50, pageId:pageId),
  const Button(buttonId: '16', x: 10, y: 190, width: 50, height: 50, pageId: pageId),
  const Button(buttonId: '17', x: 70, y: 190, width: 50, height: 50, pageId: pageId),
  const Button(buttonId: '18', x: 130, y: 190, width: 50, height: 50, pageId:pageId),
  const Button(buttonId: '19', x: 190, y: 190, width: 50, height: 50, pageId:pageId),
  const Button(buttonId: '20', x: 10, y: 250, width: 50, height: 50, pageId: pageId),
  const Button(buttonId: '21', x: 70, y: 250, width: 50, height: 50, pageId: pageId),
  const Button(buttonId: '22', x: 130, y: 250, width: 50, height: 50, pageId:pageId),
  const Button(buttonId: '23', x: 190, y: 250, width: 50, height: 50, pageId:pageId),
];

// list permutation for buttons to appear in pseudo random order
int seed = 53;
Random random = Random(seed);
RandomList randomList = RandomList(20, random);
List<int> permutedList = randomList.generate();

//
class ContinuousTargetPage extends ConsumerStatefulWidget {
  const ContinuousTargetPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContinuousTargetPageState();
}

class _ContinuousTargetPageState extends ConsumerState<ContinuousTargetPage> {
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
        if (currentButtonIndex <= buttons.length)
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
              updateDx: 1.2,
              updateDy: 1.2,
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
      ],
    ));
  }
}
