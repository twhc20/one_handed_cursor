import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/providers/cursor_notifier.dart';

@immutable
class CursorState {
  final double positionX;
  final double positionY;
  final double radius;

  const CursorState(
      {this.positionX = 0, this.positionY = 0, this.radius = 10.0});
}

// final cursorNotifier = StateNotifierProvider<CursorNotifier, CursorState>(
//     (ref) => CursorNotifier());

final cursorNotifierProvider = StateNotifierProvider.family<CursorNotifier, CursorState, CursorWidget>(
  (ref, cursorWidget) => CursorNotifier(
    cursorWidget.initialPositionX,
    cursorWidget.initialPositionY,
    cursorWidget.radius,
  ),
);

class CursorWidget extends ConsumerWidget {
  final double initialPositionX;
  final double initialPositionY;
  final double radius;

  const CursorWidget({
    this.initialPositionX = 0,
    this.initialPositionY = 0,
    this.radius = 10,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cursorPosition = ref.watch(cursorNotifierProvider(this));

    final screenSize = MediaQuery.of(context).size;

    return Stack(children: [
      Positioned(
        left: cursorPosition.positionX - radius.clamp(0, screenSize.width - radius * 2),
        top: cursorPosition.positionY - radius.clamp(0, screenSize.height - radius * 2),
        child: Container(
          width: cursorPosition.radius * 2,
          height: cursorPosition.radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
    ]);
  }
}
