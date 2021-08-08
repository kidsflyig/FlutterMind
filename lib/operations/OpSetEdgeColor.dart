import 'dart:ui';

import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/operations/History.dart';

import 'Operation.dart';

class OpSetEdgeColor extends Operation {
  Color color_before;
  Color color_after;

  static OpSetEdgeColor create(color) {
    OpSetEdgeColor op = OpSetEdgeColor(color);
    return op;
  }

  OpSetEdgeColor(color):super("setEdgeColor") {
    Settings s = Settings();
    color_before = s.edgeColor;
    color_after = color;
  }

  void doAction() {
    Settings s = Settings();
    s.edgeColor = color_after;
    MapController().repaint();
    super.doAction();
  }

  void undoAction() {
    Settings s = Settings();
    s.edgeColor = color_before;
    MapController().repaint();
    super.undoAction();
  }
}
