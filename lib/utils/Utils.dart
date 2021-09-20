import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utils {
  bool is_android = false;
  bool is_ios = false;
  bool is_web = false;

  Utils._privateConstructor() {
    try {
      if (Platform.isIOS) {
        print("is ios");
        is_ios = true;
      } else if (Platform.isAndroid) {
        print("is andrid");
        is_android = true;
      }
    } catch(UnsupportedError) {
      print("is web");
      is_web = true;
    }
  }

  static Utils _instance = null;

  factory Utils() {
    if (_instance == null) {
      _instance = Utils._privateConstructor();
    }
    return _instance;
  }

  bool get isAndroid => is_android;
  bool get isIOS => is_ios;
  bool get isWeb => is_web;

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

  static void disableStatusBar() {
    if (Utils().isAndroid) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  static Image default_img() {
    return Image.asset("assets/image/test.jpg");
  }
}