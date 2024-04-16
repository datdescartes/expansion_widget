import 'dart:math' as math;

import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? _expanded2;
  final _key3 = GlobalKey<ExpansionWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Expansion Widget Demo')),
      body: Column(
        children: [
          Card(
            color: Colors.white,
            child: ExpansionWidget.autoSaveState(
                initiallyExpanded: true,
                titleBuilder:
                    (double animationValue, _, bool isExpaned, toogleFunction) {
                  return InkWell(
                      onTap: () => toogleFunction(animated: true),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                                child: Text('1. Expansion Widget Title 1')),
                            Transform.rotate(
                              angle: math.pi * animationValue / 2,
                              alignment: Alignment.center,
                              child: const Icon(Icons.arrow_right, size: 40),
                            )
                          ],
                        ),
                      ));
                },
                content: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: const Text('Expaned Content'),
                )),
          ),
          Card(
            clipBehavior: Clip.hardEdge,
            child: ExpansionWidget(
                onSaveState: (context, value) => _expanded2 = value,
                onRestoreState: (context) => _expanded2,
                duration: const Duration(seconds: 1),
                titleBuilder:
                    (_, double easeInValue, bool isExpaned, toogleFunction) {
                  return Material(
                    color: Color.lerp(
                        Colors.red.shade100, Colors.orange, easeInValue),
                    child: InkWell(
                        onTap: () => toogleFunction(animated: true),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Text('2. Title 2',
                                      style: TextStyle(
                                          color: Color.lerp(Colors.black,
                                              Colors.white, easeInValue)))),
                              Transform.rotate(
                                  angle: -math.pi * 2 * (easeInValue),
                                  child: const Icon(Icons.settings,
                                      size: 40, color: Colors.white)),
                              Container(
                                color: Colors.transparent,
                                height: 1,
                                width: easeInValue * math.pi * 40,
                              ),
                              Transform.rotate(
                                angle: math.pi * (easeInValue + 0.5),
                                alignment: Alignment.center,
                                child: Icon(Icons.arrow_back,
                                    size: 40,
                                    color: Color.lerp(Colors.white,
                                        Colors.black, easeInValue)),
                              )
                            ],
                          ),
                        )),
                  );
                },
                content: Container(
                  width: double.infinity,
                  color: Colors.orange,
                  padding: const EdgeInsets.all(20),
                  child: const Text('Expaned Content'),
                )),
          ),
          Card(
            color: Colors.white,
            child: ExpansionWidget(
                key: _key3,
                initiallyExpanded: true,
                titleBuilder:
                    (double animationValue, _, bool isExpaned, toogleFunction) {
                  return InkWell(
                      onTap: () => toogleFunction(animated: true),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                                child: Text('3. Expansion Widget Title 3')),
                            Transform.rotate(
                              angle: math.pi * animationValue / 2,
                              alignment: Alignment.center,
                              child: const Icon(Icons.arrow_right, size: 40),
                            )
                          ],
                        ),
                      ));
                },
                content: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: const Text('Expaned Content'),
                )),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _expanded2 = !(_expanded2 ?? false);
                });
              },
              child: const Text('Toogle 2')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _key3.currentState?.toggle(animated: true);
                });
              },
              child: const Text('Toogle 3')),
        ],
      ),
    );
  }
}
