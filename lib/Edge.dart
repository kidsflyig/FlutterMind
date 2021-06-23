import 'dart:collection';

import 'package:flutter/material.dart';

import 'widgets/BezierEdgetWidget.dart';
import 'widgets/EdgeWidget.dart';
import 'Node.dart';

class Edge {
  Node from;
  Node to;
  Widget _widget;
  Edge(this.from, this.to) {
    from.addEdge(this, true);
    to.addEdge(this, false);
  }

  Widget widget() {
    print("edge hash="+this.hashCode.toString()+", widget="+_widget.hashCode.toString());
    if (_widget == null) {
      var key = ObjectKey(this.hashCode);
      print("create EdgetWidget " + key.toString());
      _widget = BezierEdgeWidget(key:key, from:from, to:to);
    }

    return _widget;
  }
}