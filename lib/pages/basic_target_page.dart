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

// list permutation for buttons to appear in pseudo random order
int seed = 42;
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
