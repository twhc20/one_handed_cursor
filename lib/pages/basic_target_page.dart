import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/custom_widgets/button.dart';
import 'package:one_handed_cursor/custom_widgets/cursor.dart';
import 'package:one_handed_cursor/helper_functions/random_list.dart';
import 'package:one_handed_cursor/pages/home_page.dart';
import 'package:one_handed_cursor/providers/button_index_provider.dart';
import '../csv/csv.dart';

const String pageId = 'basic_target_page';
// List of buttons
// Each button has an id, x, y, width, height
final buttons = [
  const Button(buttonId: 'basic1', x: 30, y: 34, pageId: pageId),
  const Button(buttonId: 'basic2', x: 145, y: 86, pageId: pageId),
  const Button(buttonId: 'basic3', x: 87, y: 237, pageId: pageId),
  const Button(buttonId: 'basic4', x: 133, y: 152, pageId: pageId),
  const Button(buttonId: 'basic5', x: 54, y: 286, pageId: pageId),
  const Button(buttonId: 'basic6', x: 230, y: 56, pageId: pageId),
  const Button(buttonId: 'basic7', x: 264, y: 90, pageId: pageId),
  const Button(buttonId: 'basic8', x: 290, y: 384, pageId: pageId),
  const Button(buttonId: 'basic9', x: 297, y: 230, pageId: pageId),
  const Button(buttonId: 'basic10', x: 370, y: 130, pageId: pageId),
  const Button(buttonId: 'basic11', x: 35, y: 499, pageId: pageId),
  const Button(buttonId: 'basic12', x: 99, y: 443, pageId: pageId),
  const Button(buttonId: 'basic13', x: 43, y: 630, pageId: pageId),
  const Button(buttonId: 'basic14', x: 157, y: 699, pageId: pageId),
  const Button(buttonId: 'basic15', x: 115, y: 570, pageId: pageId),
  const Button(buttonId: 'basic16', x: 256, y: 483, pageId: pageId),
  const Button(buttonId: 'basic17', x: 287, y: 544, pageId: pageId),
  const Button(buttonId: 'basic18', x: 301, y: 601, pageId: pageId),
  const Button(buttonId: 'basic19', x: 275, y: 643, pageId: pageId),
  const Button(buttonId: 'basic20', x: 336, y: 770, pageId: pageId),
];

// list permutation for buttons to appear in pseudo random order
int seed = 53;
Random random = Random(seed);
RandomList randomList = RandomList(20, random);
List<int> permutedList = randomList.generate();

//
class BasicTargetPage extends ConsumerStatefulWidget {
  const BasicTargetPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BasicTargetPageState();
}

class _BasicTargetPageState extends ConsumerState<BasicTargetPage> {
  // cursor widget
  final cursorWidget = const CursorWidget(initialPositionX: 50);

  // variables for starting test
  bool started = false;
  bool next = false;

  // variables for stopwatch
  final stopWatch = Stopwatch();
  final splitStopwatch = Stopwatch();

  // data to be saved
  List<String> data = [participantId, pageId];

  @override
  Widget build(BuildContext context) {
    final currentButtonIndex = ref.watch(buttonIndexProvider(pageId));

    ref.listen<int>(buttonIndexProvider(pageId), (int? prevValue, int value) {
      stopWatch.stop();
      splitStopwatch.stop();
      int splitTime = splitStopwatch.elapsedMilliseconds;
      int overallTime = stopWatch.elapsedMilliseconds;
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
                    rowsNoCursor.add(data);
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
