import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/operations/History.dart';

import 'Operation.dart';

class OpSetScale extends Operation {
  double scale_level_before;
  double scale_level_after;

  static OpSetScale create(scale_level) {
    OpSetScale op = OpSetScale(scale_level);
    return op;
  }

  OpSetScale(scale_level):super("setScale") {
    Settings s = Settings();
    scale_level_before = s.scaleLevel;
    scale_level_after = scale_level;
  }

  void doAction() {
    Settings s = Settings();
    s.scaleLevel = scale_level_after;
    MapController().repaint();
    super.doAction();
  }

  void undoAction() {
    Settings s = Settings();
    s.scaleLevel = scale_level_before;
    MapController().repaint();
    super.undoAction();
  }
}
