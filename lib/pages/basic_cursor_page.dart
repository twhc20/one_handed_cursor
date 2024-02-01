import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/custom_widgets/cursor.dart';
import 'package:one_handed_cursor/custom_widgets/touchpad.dart';

class BasicCursorPage extends ConsumerWidget {
  const BasicCursorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('Custom Cursor'),
        ),
        body: Stack(
          children: [
            const CursorWidget(),
            Touchpad(
                onUpdatePosition: (double x, double y) {
                  ref.read(cursorNotifier.notifier).updatePosition(x, y);
                },
                onTap: () {})
          ],
        ));
  }
}
