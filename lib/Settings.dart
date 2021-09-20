import 'dart:ui';

import 'package:FlutterMind/StyleManager.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:flutter/material.dart';

enum MapMode {
  star,
  bidi
}

class Settings {
  MapMode mode = MapMode.bidi;
  double _default_scale_level;
  Color _background_color;
  Color _edge_color;
  Size _default_root_size;
  double _distance = 100;
  Style _default_template;

  Settings._privateConstructor() {
    _init();
  }

  static Settings _instance = null;

  void _init() {
     _default_template = Style("default");
    _default_scale_level = 5;

    _background_color = Colors.white;
    _edge_color = Colors.yellow;
    _default_root_size = Size(100, 50);
  }

  factory Settings() {
    if (_instance == null) {
      _instance = Settings._privateConstructor();
    }
    return _instance;
  }

  double get scaleLevel => _default_scale_level;

  set scaleLevel(double level) {
    _default_scale_level = level;
  }

  double get distance => _distance;

  void setDistanceByFontSize(double size) {
    _distance = 120 + (size - 20) * 2;
  }

  Color get backgroundColor => _background_color;

  set backgroundColor(Color color) {
    _background_color = color;
  }

  Color get edgeColor => _edge_color;

  set edgeColor(Color color) {
    _edge_color = color;
  }

  Size get rootNodeSize => _default_root_size;

  Style defaultStyle() {
    return _default_template;
  }
}