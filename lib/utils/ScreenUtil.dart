import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';

final int main_menu_padding_left = 0;
final int plain_text_node_width = 1;
final int plain_text_node_font_size_100p = 2;

class ScreenUtil {
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
  static HashMap<int, double> screen = new HashMap<int, double>();
  static void initScreen() {
    double width = mediaQuery.size.width;
    if ( width <= 720)  {
      initScreenlt720();
    } else if (width <= 1048) {
      initScreenlt1048();
    } else if (width <= 1366) {
      initScreenlt366();
    } else {
      print("no fitfull size config"+width.toString());
    }
  }

  static void initScreenlt720() {
    screen[main_menu_padding_left] = 50;
    screen[plain_text_node_width] = 100;
    screen[plain_text_node_font_size_100p] = 10;
  }

  static void initScreenlt1048() {
    screen[main_menu_padding_left] = 50;
    screen[plain_text_node_width] = 100;
    screen[plain_text_node_font_size_100p] = 10;
  }

  static void initScreenlt366() {
    screen[main_menu_padding_left] = 50;
    screen[plain_text_node_width] = 100;
    screen[plain_text_node_font_size_100p] = 10;
  }

  static double getDp(int id) {
    double res = screen[id];
    return res;
  }
}