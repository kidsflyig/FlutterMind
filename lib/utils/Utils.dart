import 'dart:ui';

import 'package:flutter/material.dart';

class Utils {

  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);

  static Offset position(GlobalKey key) {
    RenderBox box = key.currentContext.findRenderObject();
    Offset offset = box.localToGlobal(Offset.zero);
    return offset;
  }

  static Size screenSize() {
    return MediaQueryData.fromWindow(window).size;
  }

  static Offset center() {
    return Offset(screenSize().width / 2, screenSize().height / 2);
  }
}