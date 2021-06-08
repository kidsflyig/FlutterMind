import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'Node.dart';

class Layout {
  final double PI = 3.14159;
  double divider = 4;
  double direction = 0;
  double distance = 100;
  Set<int> positioned = new HashSet<int>();
  Node node;
  Layout(this.node) {
    if (node.type == NodeType.rootNode) {
      divider = 4;
    } else {
      divider = 50; // node
    }
  }

  void relayoutAll() {
      node.children?.forEach((e) {
        layoutInternal(e);
      });
  }

  void layoutInternal(Node child) {
    print("layoutInternal1 " + divider.toString());
    for (int i = 0; i<divider; i++) {
      if (positioned.lookup(i) == null) {
        print("layoutInternal2 " + i.toString());
        positioned.add(i); // a position found!
        child.layout.direction = (360 / divider) * i;
        child.left = node.left + distance * cos(PI / 180 * child.layout.direction);
        child.top = node.top + distance * sin(PI / 180 * child.layout.direction);

        print("layoutInternal3 " + child.left.toString()+" , "+child.top.toString());
        return;
      }
    }
  }

  void layout(Node child) {
    if (node.type == NodeType.rootNode) {
      if (node.children.length > divider) {
        divider *= 2;
        positioned.clear();
        distance *= 2;
        relayoutAll();
        print("layout1");
      } else {
        print("layout2");
        layoutInternal(child);
      }
    } else {

    }
  }
}