import 'dart:ui';

import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/operations/History.dart';

import 'Operation.dart';

class OpSetNodeBgColor extends Operation {
  Color color_before;
  Color color_after;

  static OpSetNodeBgColor create(color) {
    OpSetNodeBgColor op = OpSetNodeBgColor(color);
    return op;
  }

  OpSetNodeBgColor(color):super("setNodeBgColor") {
    Settings s = Settings();
    color_before = s.nodeBgColor;
    color_after = color;
  }

  void doAction() {
    Settings s = Settings();
    s.nodeBgColor = color_after;
    MapController().repaint();
    super.doAction();
  }

  void undoAction() {
    Settings s = Settings();
    s.nodeBgColor = color_before;
    MapController().repaint();
    super.undoAction();
  }
}
