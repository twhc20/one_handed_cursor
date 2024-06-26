import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/providers/button_index_provider.dart';

final counterStateProvider = StateProvider.family.autoDispose((ref, id) => 0);

class Button extends ConsumerWidget {
  final double x;
  final double y;
  final double width;
  final double height;
  final String buttonId;
  final String pageId;

  const Button(
      {this.x = 0,
      this.y = 0,
      this.width = 24,
      this.height = 24,
      required this.buttonId,
      required this.pageId,
      super.key});

  Rect getRect() {
    return Rect.fromLTWH(x, y, width, height);
  }

  void onTap(WidgetRef ref) async {
    await Future.delayed(const Duration(milliseconds: 10));
    ref.read(counterStateProvider(buttonId).notifier).state++;
    ref.read(buttonIndexProvider(pageId).notifier).state++;
    await Future.delayed(const Duration(milliseconds: 10));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
        left: x,
        top: y,
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: SizedBox(
              width: width,
              height: height,
              child: ElevatedButton(
                onPressed: () => onTap(ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(''),
              ),
            )));
  }
}
