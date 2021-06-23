import 'dart:collection';
// import 'dart:html';
import 'dart:math';

import 'package:FlutterMind/Foreground.dart';
import 'package:FlutterMind/layout/Layout.dart';
import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:flutter/material.dart';

import '../Edge.dart';
import 'EdgeWidget.dart';
import '../MapController.dart';
import '../Node.dart';
import 'EdgeWidgetBase.dart';

class PlaceHolderWidget extends NodeWidgetBase {
  Direction _direction;
  Offset origin = Offset(0, 0);
  Offset offset = Offset(0, 0);
  Size size;
  NodeWidgetBase widget;

  PlaceHolderWidget(this.widget, target, direction) {
    update(target, direction);
  }

  void update(target, direction) {
    origin = Offset(target.left + 5, target.top + 5);
    offset = origin;
    size = Size(target.width - 10, target.height - 10);

    this.direction = direction;
  }


  Direction get direction => _direction;

  set direction(dir) {
    // if (_direction == dir) return;
    this._direction = dir;
    if (dir == Direction.top) {
      offset = origin.translate(0, -10);
    } else if (dir == Direction.right) {
      offset = origin.translate(10, 0);
    } else if (dir == Direction.bottom) {
      offset = origin.translate(0, 10);
    } else if (dir == Direction.left) {
      offset = origin.translate(-10, 0);
    }

    state?.setState(() {});
  }

  static PlaceHolderWidget cast(Widget w) {
    if (w is PlaceHolderWidget) {
      return w;
    }
    return null;
  }

  @override
  State<StatefulWidget> createState() {
    state = PlaceHolderWidgetState();
    return state;
  }
}

class PlaceHolderWidgetState extends State<PlaceHolderWidget> {

  @override
  Widget build(BuildContext context) {
    return Positioned(
        //margin: EdgeInsets.only(left: widget.moveOffset.dx, top: widget.moveOffset.dy),
        //color: Colors.purple,
        left: widget.offset.dx,
        top: widget.offset.dy,
        child: Container(
      width: widget.size.width,
      height: widget.size.height,
      color:  Colors.red,
    ));
  }
}