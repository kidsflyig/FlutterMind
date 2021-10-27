import 'dart:math';

import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/TreeNode.dart';
import 'package:FlutterMind/widgets/BezierEdge.dart';
import 'package:flutter/material.dart';

import 'NodeWidgetBase.dart';
import '../utils/Utils.dart';

class Edge extends StatefulWidget {
  TreeNode from;
  TreeNode to;

  Edge({
    Key key
  }) : super(key: key);

  static Edge create(TreeNode f, TreeNode t) {
    var key = UniqueKey();
    BezierEdge w = BezierEdge(key:key);
    w.from = f;
    w.to = t;
    f.addEdge(w, true);
    t.addEdge(w, false);
  }

  void repaint() {
  }

  Color get color {
    return Settings().edgeColor;
  }

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}
