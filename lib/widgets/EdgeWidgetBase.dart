import 'dart:math';

import 'package:flutter/material.dart';

import '../Node.dart';
import 'NodeWidgetBase.dart';
import '../utils/Utils.dart';

class EdgeWidgetBase extends StatefulWidget {
  final Node from;
  final Node to;
  EdgeWidgetBase({
    Key key,
    this.from,
    this.to
  }) : super(key: key);

  void update() {

  }

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}
