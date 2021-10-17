import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:FlutterMind/utils/Constants.dart';

class ScreenUtil {
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
  static HashMap<int, double> screen = new HashMap<int, double>();
  static void initScreen() {
    double width = mediaQuery.size.width;
    print("initScreen width="+width.toString());

    if ( width <= 720)  {
      initScreenlt720();
    } else if (width <= 1048) {
      initScreenlt1048();
    } else if (width <= 1366) {
      initScreenlt1366();
    } else {
      print("no fitfull size config"+width.toString());
    }
  }

  static double getDp(int id) {
    double res = screen[id];
    return res;
  }

  static void initScreenlt720() {
    screen[C.main_menu_padding_left] = 50;
    screen[C.plain_text_node_width] = 100;
    screen[C.plain_text_node_font_size_100p] = 10;
    screen[C.bottom_toolbar_toggle_button_width] = 50;
    screen[C.bottom_toolbar_item_bg_width] = 50;
    screen[C.top_toolbar_btn_width] = 30;
    screen[C.dialog_file_btn_width] = 50;
  }

  static void initScreenlt1048() {
    screen[C.main_menu_padding_left] = 50;
    screen[C.plain_text_node_width] = 100;
    screen[C.plain_text_node_font_size_100p] = 20;
    screen[C.bottom_toolbar_toggle_button_width] = 50;
    screen[C.bottom_toolbar_item_bg_width] = 50;
    screen[C.top_toolbar_btn_width] = 30;
    screen[C.dialog_file_btn_width] = 50;
  }

  static void initScreenlt1366() {
    screen[C.main_menu_padding_left] = 50;
    screen[C.plain_text_node_width] = 100;
    screen[C.plain_text_node_font_size_100p] = 30;
    screen[C.bottom_toolbar_toggle_button_width] = 50;
    screen[C.bottom_toolbar_item_bg_width] = 50;
    screen[C.top_toolbar_btn_width] = 30;
    screen[C.dialog_file_btn_width] = 50;
  }
}