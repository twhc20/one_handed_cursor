import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_handed_cursor/providers/button_index_provider.dart';

final counterStateProvider = StateProvider.family.autoDispose((ref, id) => 0);

class ButtonCopy extends ConsumerStatefulWidget {
  final double x;
  final double y;
  final double width;
  final double height;
  final String buttonId;
  final String pageId;

  const ButtonCopy(
      {this.x = 0,
      this.y = 0,
      this.width = 100,
      this.height = 100,
      required this.buttonId,
      required this.pageId,
      super.key});

  Rect getRect() {
    return Rect.fromLTWH(x, y, width, height);
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ButtonState();

  void onTap(WidgetRef ref) {}
}

class _ButtonState extends ConsumerState<ButtonCopy> {
  Color color = Colors.blue;

  void onTap(WidgetRef ref) async {
    await Future.delayed(const Duration(milliseconds: 10));

    setState(() {
      color = Colors.green;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        color = Colors.blue;
      });
    });

    ref.read(counterStateProvider(widget.buttonId).notifier).state++;
    ref.read(buttonIndexProvider(widget.pageId).notifier).state++;
  }

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(counterStateProvider(widget.buttonId));
    return Positioned(
        left: widget.x,
        top: widget.y,
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: SizedBox(
              width: widget.height,
              height: widget.height,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ElevatedButton(
                  onPressed: () => onTap(ref),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Text('Counter: $value'),
                ),
              ),
            )));
  }
}
