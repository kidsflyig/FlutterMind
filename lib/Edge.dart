import 'dart:collection';

import 'package:FlutterMind/utils/Log.dart';
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

  void update(Node from, Node to) {
    Log.e("edge update");
    this.from = from;
    this.to = to;
    from.addEdge(this, true);
    to.addEdge(this, false);
    dynamic w = widget();
    w.update(this);
  }

  Widget widget() {
    if (_widget == null) {
      var key = ObjectKey(this.hashCode);
      print("create EdgetWidget " + key.toString());
      _widget = BezierEdgeWidget(key:key, edge:this);
    }

    return _widget;
  }
}