import 'dart:ui';

import 'package:FlutterMind/layout/BidiLayout.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';

import 'base.dart';

class HitTestResult {
  int score = 0;
  bool hit = false;
  NodeWidgetBase widget;
  Rect target;
  Direction direction;
}