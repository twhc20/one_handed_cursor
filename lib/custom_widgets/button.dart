import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterStateProvider = StateProvider.family.autoDispose((ref, id) => 0);

class Button extends ConsumerWidget {
  final double x;
  final double y;
  final double width;
  final double height;
  final String id;

  const Button(
      {this.x = 0,
      this.y = 0,
      this.width = 100,
      this.height = 100,
      required this.id,
      super.key});

  Rect getRect() {
    return Rect.fromLTWH(x, y, width, height);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(counterStateProvider(id));
    return Positioned(
        left: x,
        top: y,
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: SizedBox(
              width: width,
              height: height,
              child: ElevatedButton(
                onPressed: () => ref
                    .read(counterStateProvider(id).notifier)
                    .state++, 
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: Text('Counter: $value'),
              ),
            )));
  }
}
