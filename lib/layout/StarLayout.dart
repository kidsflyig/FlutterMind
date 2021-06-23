import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/widgets/RootNodeWidget.dart';

import '../Node.dart';
import 'Layout.dart';

class StarLayout extends Layout {
  final double PI = 3.14159;
  double divider = 4;
  double direction = -1;
  double distance = 100;
  Set<int> positioned = new HashSet<int>();

  StarLayout(widget) : super(widget) {
    if (widget is RootNodeWidget) {
      divider = 4;
    } else {
      divider = 15; // node
    }
  }

  StarLayout ToStarLayout(Layout l) {
    if (l is StarLayout) {
      return l;
    }

    return null;
  }

  void relayoutAll(angle) {
    positioned.clear();
    children?.forEach((e) {
    if (ToStarLayout(e).direction > 0) {
      positioned.add((ToStarLayout(e).direction - angle) ~/ divider);
      print("child take direction in " + (ToStarLayout(e).direction ~/ divider).toString());
      return;
    }});
  }

  void layoutRootChildren(Node child) {
    print("layoutInternal1 " + divider.toString());
    for (int i = 0; i<divider; i++) {
      if (positioned.lookup(i) == null) {
        print("layoutInternal2 " + i.toString());
        positioned.add(i); // a position found!
        ToStarLayout(child.layout).direction = (360 / divider) * i;
        Offset pos = NodeWidgetBase.ToNodeWidgetBase(widget).offset;
        var left = pos.dx + distance * cos(PI / 180 * ToStarLayout(child.layout).direction);
        var top = pos.dy + distance * sin(PI / 180 * ToStarLayout(child.layout).direction);
        NodeWidgetBase.ToNodeWidgetBase(child.widget()).moveToPosition(Offset(left, top));
        print("layoutInternal3 " + NodeWidgetBase.ToNodeWidgetBase(child.widget()).offset.toString());
        return;
      }
    }
  }

  void layoutLeafChildren(child) {
    print("layoutLeafChildren1 " + divider.toString());
    int alg = 0;
    int i = 0;
    double angle = 0;
    while(positioned.lookup(i) != null) {
      if (alg == 0) {
        angle = (-angle) + divider;
        alg = 1;
      } else {
        angle = -angle;
        alg = 0;
      }
      i = angle ~/ divider;
    }
    positioned.add(i); // a position found!

    print("layoutLeafChildren2 " + i.toString()+" , angle=" + angle.toString());
    print("node direction = " + ToStarLayout(child.layout).direction.toString());
    ToStarLayout(child.layout).direction = ToStarLayout(child.layout).direction + angle;
    Offset pos = NodeWidgetBase.ToNodeWidgetBase(widget).offset;
    var left = pos.dx + distance * cos(PI / 180 * ToStarLayout(child.layout).direction);
    var top = pos.dy + distance * sin(PI / 180 * ToStarLayout(child.layout).direction);

    NodeWidgetBase.ToNodeWidgetBase(widget).moveToPosition(Offset(left, top));
    return;
  }

  void layout(child) {
    if (child is RootNodeWidget) {
      print("layout " + positioned.length.toString() +", "+ divider.toString());
      if (positioned.length >= divider) {
        relayoutAll(0);
        divider = (positioned.length * 2).toDouble();
        distance = distance + 100;

        print("layout1");
      } else {
        print("layout2");
      }
      layoutRootChildren(child);
    } else {
      relayoutAll(ToStarLayout(child.layout).direction);
      layoutLeafChildren(child);
      // Offset c = Offset(Utils.screenSize().width * 3 / 2, Utils.screenSize().height * 3 / 2);
      // child.left = c.dx;
      // child.top = c.dy;
    }
  }
}