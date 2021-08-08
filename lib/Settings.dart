import 'dart:ui';

import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:flutter/material.dart';

enum MapMode {
  star,
  bidi
}

class Settings {
  MapMode mode = MapMode.bidi;
  double _default_font_size;
  double _default_scale_level;
  bool _default_font_weight;
  String _default_font_family;
  Color _background_color;
  Color _node_bg_color;
  Color _edge_color;
  Size _default_root_size;

  Settings._privateConstructor() {
    _init();
  }

  static Settings _instance = null;

  void _init() {
    _default_font_size = ScreenUtil.getDp(plain_text_node_font_size_100p);
    _default_font_weight = false;
    _default_font_family = "";
    _default_scale_level = 5;
    _background_color = Colors.white;
    _node_bg_color = Colors.lightBlue;
    _edge_color = Colors.yellow;
    _default_root_size = Size(200, 100);
  }

  factory Settings() {
    if (_instance == null) {
      _instance = Settings._privateConstructor();
    }
    return _instance;
  }

  double get fontSize => _default_font_size;

  set fontSize(double size) {
    _default_font_size = size;
  }

  bool get fontWeight => _default_font_weight;

  set fontWeight(bool weight) {
    _default_font_weight = weight;
  }

  String get fontFamily => _default_font_family;

  set fontFamily(String family) {
    _default_font_family = family;
  }

  double get scaleLevel => _default_scale_level;

  set scaleLevel(double level) {
    _default_scale_level = level;
  }

  double get distance => 200 + (_default_scale_level - 5) * 10;

  Color get backgroundColor => _background_color;

  set backgroundColor(Color color) {
    _background_color = color;
  }

  Color get nodeBgColor => _node_bg_color;

  set nodeBgColor(Color color) {
    _node_bg_color = color;
  }

  Color get edgeColor => _edge_color;

  set edgeColor(Color color) {
    _edge_color = color;
  }

  Size get rootNodeSize => _default_root_size;

}