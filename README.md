# expansion_widget

An edited version of Expansion Tile that allows you customize tile widget and animation.

![demo](https://raw.githubusercontent.com/datdescartes/expansion_widget/master/demo.gif)

## Usage

```
import 'package:expansion_widget/expansion_widget.dart';
import 'dart:math' as math;

ExpansionWidget(
    initiallyExpanded: true,
    titleBuilder: (double animationValue, _, bool isExpaned, toogleFunction) {
      return InkWell(
          onTap: () => toogleFunction(animated: true),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text('Expansion Widget Title 1')),
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
      color: Colors.grey.shade100,
      padding: EdgeInsets.all(20),
      child: Text('Expaned Content'),
    ))
```

