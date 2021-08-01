import 'dart:ui';

import 'package:FlutterMind/utils/ScreenUtil.dart';

enum MapMode {
  star,
  bidi
}

class Settings {
  MapMode mode = MapMode.bidi;
  double default_font_size;
  bool default_font_weight;
  String default_font_family;

  Settings._privateConstructor() {
    _init();
  }

  static Settings _instance = null;

  void _init() {
    default_font_size = ScreenUtil.getDp(plain_text_node_font_size_100p);
    default_font_weight = false;
    default_font_family = "";
  }

  factory Settings() {
    if (_instance == null) {
      _instance = Settings._privateConstructor();
    }
    return _instance;
  }
}