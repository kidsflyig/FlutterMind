import 'dart:collection';

import 'package:flutter/material.dart';

import 'EdgeWidget.dart';
import 'Node.dart';

class Edge {
  Node from;
  Node to;
  Widget _widget;
  Edge(this.from, this.to) {
    from.addEdge(this);
    to.addEdge(this);
  }

  Widget widget() {
    _widget = _widget ?? EdgeWidget(from, to);
    return _widget;
  }
}