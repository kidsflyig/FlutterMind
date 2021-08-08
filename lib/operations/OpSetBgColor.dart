import 'dart:ui';

import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/operations/History.dart';

import 'Operation.dart';

class OpSetBgColor extends Operation {
  Color color_before;
  Color color_after;

  static OpSetBgColor create(color) {
    OpSetBgColor op = OpSetBgColor(color);
    return op;
  }

  OpSetBgColor(color):super("setBgColor") {
    Settings s = Settings();
    color_before = s.backgroundColor;
    color_after = color;
  }

  void doAction() {
    Settings s = Settings();
    s.backgroundColor = color_after;
    MapController().repaintBackground();
    super.doAction();
  }

  void undoAction() {
    Settings s = Settings();
    s.backgroundColor = color_before;
    MapController().repaintBackground();
    super.undoAction();
  }
}
