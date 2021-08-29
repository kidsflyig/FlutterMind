import 'dart:ui';

import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/StyleManager.dart';
import 'package:FlutterMind/operations/History.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';

import 'Operation.dart';

class OpSetNodeBgColor extends Operation {
  Color color_before;
  Color color_after;
  NodeWidgetBase widget;

  static OpSetNodeBgColor create(color, widget) {
    OpSetNodeBgColor op = OpSetNodeBgColor(color, widget);
    return op;
  }

  OpSetNodeBgColor(color, this.widget):super("setNodeBgColor") {
    Style style = Style.styleForWidget(widget);
    color_before = style.bgColor();
    color_after = color;
  }

  void doAction() {
    Style style = Style.styleForWidget(widget);
    style.setBackgroundColor(color_after);
    MapController().repaint();
    super.doAction();
  }

  void undoAction() {
    Style style = Style.styleForWidget(widget);
    style.setBackgroundColor(color_before);
    MapController().repaint();
    super.undoAction();
  }
}
