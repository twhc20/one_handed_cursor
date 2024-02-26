import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/custom_widgets/button.dart';
import 'package:one_handed_cursor/custom_widgets/cursor.dart';
import 'package:one_handed_cursor/custom_widgets/touchpad.dart';

final buttons = [
  const Button(id: '1', x: 16.0, y: 100.0),
  const Button(id: '2', x: 16.0, y: 250.0),
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
            Touchpad(onUpdatePosition: (double x, double y) {
              cursorNotifier.updatePosition(x, y);
            }, onTap: () {
              for (var button in buttons) {
                if (cursorNotifier.isCursorOnButton(button)) {
                  button.onTap(ref);
                }
              }
            })
          ],
        ));
  }
}
