import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:FlutterMind/TreeNode.dart';
import 'package:FlutterMind/layout/BidiLayout.dart';
import 'package:FlutterMind/layout/LayoutController.dart';
import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/utils/base.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';

import '../Document.dart';
import '../Settings.dart';
import 'StarLayout.dart';

class LayoutObject {
  LayoutObject(this.widget) {
  }

  NodeWidgetBase widget;
  // Layout parent;
  // List<Layout> children;
  bool dirty = true;
  DragUtil drag_ = DragUtil();
  double _width = 0;
  double _height = 0;

  double get width => _width;
  double get height => _height;

  void set width(double width) {
    _width = width;
    markParentDirty();
  }

  void set height(double height) {
    _height = height;
    markParentDirty();
  }

  void resize() {}
  void relayout() {
  }

  void markParentDirty() {
    Log.e("markParentDirty1 " + widget.hashCode.toString());
    if (dirty != true) {
      Log.e("markParentDirty2 isRoot=" + widget.isRoot.toString());
      dirty = true;
    }
    if (widget.isRoot) {
      return;
    }
    Log.e("markParentDirty3 " + this.toString());
    widget.parent.layout.markParentDirty();
  }

  void onPanStart(detail) {
    drag_.onPanStart(detail);
  }

  void onPanUpdate(detail) {
    drag_.onPanUpdate(detail);
  }

  void onPanEnd(detail) {
    drag_.onPanEnd(detail);
  }

  void moveToPosition(Offset offset) {
    drag_.moveToPosition(offset);

    LayoutController().updateMapRect(
      Rect.fromLTWH(drag_.moveOffset.dx, drag_.moveOffset.dy, width, height));
  }

  void moveByOffset(Offset offset) {
    drag_.moveByOffset(offset);

    LayoutController().updateMapRect(
      Rect.fromLTWH(drag_.moveOffset.dx, drag_.moveOffset.dy, width, height));
  }

  double get x {
    return drag_.moveOffset.dx;
  }

  double get y {
    return drag_.moveOffset.dy;
  }
}