import 'dart:math' as math;

import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? _expanded2;
  final _key3 = GlobalKey<ExpansionWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Expansion Widget Demo')),
      body: Column(
        children: [
          Card(
            color: Colors.white,
            child: ExpansionWidget(
                initiallyExpanded: true,
                titleBuilder:
                    (double animationValue, _, bool isExpaned, toogleFunction) {
                  return InkWell(
                      onTap: () => toogleFunction(animated: true),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text('1. Expansion Widget Title 1')),
                            Transform.rotate(
                              angle: math.pi * animationValue / 2,
                              child: Icon(Icons.arrow_right, size: 40),
                              alignment: Alignment.center,
                            )
                          ],
                        ),
                      ));
                },
                content: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Text('Expaned Content'),
                )),
          ),
          Card(
            clipBehavior: Clip.hardEdge,
            child: ExpansionWidget(
                onSaveState: (value) => _expanded2 = value,
                onRestoreState: () => _expanded2,
                duration: const Duration(seconds: 1),
                titleBuilder:
                    (_, double easeInValue, bool isExpaned, toogleFunction) {
                  return Material(
                    color: Color.lerp(
                        Colors.red.shade100, Colors.orange, easeInValue),
                    child: InkWell(
                        onTap: () => toogleFunction(animated: true),
                        child: Padding(
                          padding: EdgeInsets.all(8),
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
                                  child: Icon(Icons.settings,
                                      size: 40, color: Colors.white)),
                              Container(
                                color: Colors.transparent,
                                height: 1,
                                width: easeInValue * math.pi * 40,
                              ),
                              Transform.rotate(
                                angle: math.pi * (easeInValue + 0.5),
                                child: Icon(Icons.arrow_back,
                                    size: 40,
                                    color: Color.lerp(Colors.white,
                                        Colors.black, easeInValue)),
                                alignment: Alignment.center,
                              )
                            ],
                          ),
                        )),
                  );
                },
                content: Container(
                  width: double.infinity,
                  color: Colors.orange,
                  padding: EdgeInsets.all(20),
                  child: Text('Expaned Content'),
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
                        padding: EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text('3. Expansion Widget Title 3')),
                            Transform.rotate(
                              angle: math.pi * animationValue / 2,
                              child: Icon(Icons.arrow_right, size: 40),
                              alignment: Alignment.center,
                            )
                          ],
                        ),
                      ));
                },
                content: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Text('Expaned Content'),
                )),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _expanded2 = !(_expanded2 ?? false);
                });
              },
              child: Text('Toogle 2')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _key3.currentState?.toggle(animated: true);
                });
              },
              child: Text('Toogle 3')),
        ],
      ),
    );
  }
}
