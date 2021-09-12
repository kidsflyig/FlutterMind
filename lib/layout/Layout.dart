import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:FlutterMind/layout/BidiLayout.dart';
import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/utils/base.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';

import '../Document.dart';
import '../Node.dart';
import '../Settings.dart';
import 'StarLayout.dart';

class Layout {

  NodeWidgetBase widget;
  Layout parent;
  List<Layout> children;
  bool dirty = true;
  DragUtil drag_ = DragUtil();
  double _width = 0;
  double _height = 0;
  bool attached = true;

  Layout(this.widget) {
    children = new List<Layout>();
  }

  double get width => _width;
  double get height => _height;

  void set width(double width) {
    _width = width;
    _markParentDirty(this);
  }

  void set height(double height) {
    _height = height;
    _markParentDirty(this);
  }

  void resize() {}
  void relayout() {}

  void layout(Node child) {

  }

  void removeFromParent() {
    Log.e("Layout removeFromParent " + parent.toString()+", " + this.hashCode.toString());
    parent?.removeChild(this);
  }

  void _markParentDirty(Layout l) {
    if (l == null) {
      return;
    }
    if (l.dirty == true) {
      return;
    }
    l.dirty = true;
    _markParentDirty(l.parent);
  }

  Layout root() {
    Layout l = this;
    while (l.parent != null) {
      l = l.parent;
    }
    return l;
  }

  void addChild(Layout l, Direction direction) {
    l.parent = this;
    children.add(l);
    _markParentDirty(this);
  }

  void removeChild(Layout l) {
    l.parent = null;
    children.remove(l);
    _markParentDirty(this);
  }

  void insertBefore(Layout src, Layout target) {
    Log.e("Layout insertBefore " + src.hashCode.toString()+", " + target.hashCode.toString());
    src.parent = this;
    int idx = children.indexOf(target);
    children.insert(idx, src);
  }

  void insertAfter(Layout src, Layout target) {
    Log.e("Layout insertAfter " + src.hashCode.toString()+", " + target.hashCode.toString());
    src.parent = this;
    int idx = children.indexOf(target);
    children.insert(idx + 1, src);
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
    widget.setNeedsRepaint();
    widget.repaint();
  }

  void moveByOffset(Offset offset) {
    drag_.moveByOffset(offset);
    widget.setNeedsRepaint();
    widget.repaint();
  }

  void clear() {
    children.clear();
  }

  double get x {
    return drag_.moveOffset.dx;
  }

  double get y {
    return drag_.moveOffset.dy;
  }

  void attach() {
    attached = true;
    _markParentDirty(this);
  }

  void detach() {
    attached = false;
    _markParentDirty(this);
  }
}