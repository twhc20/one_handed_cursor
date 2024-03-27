import 'package:flutter/material.dart';
import 'package:one_handed_cursor/pages/basic_cursor_page.dart';
import 'package:one_handed_cursor/pages/basic_target_page.dart';
import 'package:one_handed_cursor/pages/continuous_target_page.dart';
import 'package:one_handed_cursor/pages/generate_cursor_page.dart';
import 'package:one_handed_cursor/pages/gesture_detector_page.dart';

String participantId = '';

final TextEditingController _controller = TextEditingController();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      participantId = _controller.text;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Custom Cursor'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList.list(children: [
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Participant ID',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BasicCursorPage()));
                      },
                      child: const Text("Basic Cursor and Touchpad")),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const GestureDetectorPage()));
                      },
                      child: const Text("Gesture Detector")),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const GenerateCursorPage()));
                      },
                      child: const Text("Generate Cursor")),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BasicTargetPage()));
                      },
                      child: const Text("Basic Targets")),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ContinuousTargetPage()));
                      },
                      child: const Text("Continuous Targets")),
                ]),
                const SliverPadding(padding: EdgeInsets.only(top: 10)),
                SliverGrid.count(
                    childAspectRatio: (1 / .4),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Left small 1")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Right small 1")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Left small 1.5")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Right small 1.5")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Left big 1")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Right big 1")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Left big 1.5")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Right big 1.5")),
                      // continuous pages
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Left small 1 continuous")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Right small 1 continuous")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Left small 1.5 continuous")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Right small 1.5 continuous")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Left big 1 continuous")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Right big 1 continuous")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Left big 1.5 continuous")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateCursorPage()));
                          },
                          child: const Text("Right big 1.5 continuous")),
                    ])
              ],
            )));
  }
}
