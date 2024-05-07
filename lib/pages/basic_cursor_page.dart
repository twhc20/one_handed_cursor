import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/custom_widgets/button.dart';
import 'package:one_handed_cursor/custom_widgets/cursor.dart';
import 'package:one_handed_cursor/custom_widgets/touchpad.dart';

const String pageId = 'basic_cursor_page';

final buttons = [
  const Button(
      buttonId: '1', x: 16.0, y: 100.0, height: 24, width: 24, pageId: pageId),
  const Button(
      buttonId: '2', x: 16.0, y: 250.0, height: 48, width: 48, pageId: pageId),
];

class BasicCursorPage extends ConsumerWidget {
  const BasicCursorPage({super.key});

  final cursorWidget = const CursorWidget(initialPositionX: 50);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursorNotifier =
        ref.read(cursorNotifierProvider(cursorWidget).notifier);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Custom Cursor'),
        ),
        body: Stack(
          children: [
            ...buttons,
            cursorWidget,
            TouchpadWidget(
              cursorPositionX: cursorNotifier.getPositionX(),
              cursorPositionY: cursorNotifier.getPositionY(),
              initialLeft: 170,
              initialTop: 550,
              initialRight: 30,
              initialBottom: 50,
              updateDx: 1,
              updateDy: 1,
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
              onClose: () {},
              onSwipe: (double) {},
            ),
          ],
        ));
  }
}
