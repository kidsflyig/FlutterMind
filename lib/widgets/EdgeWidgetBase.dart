import 'dart:math';

import 'package:FlutterMind/Edge.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:flutter/material.dart';

import '../Node.dart';
import 'NodeWidgetBase.dart';
import '../utils/Utils.dart';

class EdgeWidgetBase extends StatefulWidget {
  Edge edge;
  EdgeWidgetBase({
    Key key,
    this.edge,
  }) : super(key: key);

  void update(Edge e) {

  }

  Color get color {
    return Settings().edgeColor;
  }

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}
