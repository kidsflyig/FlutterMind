import 'dart:collection';
import 'dart:ui';

import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/dialogs/SelectionListDialog.dart';
import 'package:FlutterMind/third_party/smartselection/src/model/choice_item.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:flutter/material.dart';
import 'package:FlutterMind/utils/Constants.dart';

class StyleListChangedListener {
  void onChanged(List<SelectionItem> choices) {}
}

class StyleManager {
  Map<String, Style> _templates = Map<String, Style>();
  List<StyleListChangedListener> _listeners = List<StyleListChangedListener>();

  StyleManager._privateConstructor() {
    _init();
  }

  static StyleManager _instance = null;

  void _init() {
  }

  factory StyleManager() {
    if (_instance == null) {
      _instance = StyleManager._privateConstructor();
    }
    return _instance;
  }

  void addStyleListChangedListener(value) {
    _listeners.add(value);
  }

  void removeStyleListChangedListener(value) {
    _listeners.remove(value);
  }

  Style getStyle(name) {
    Log.e("StyleManager getStyl name="+name.toString());
    return _templates[name];
  }

  void addStyle(key, value) {
    if (key == null) {
      return;
    }

    _templates.remove(key);
    _templates[key] = value;
    Log.e("addStyle " + key.toString());
    _listeners.forEach((e) {
      e.onChanged(choices());
    });
  }

  List<SelectionItem> choices() {
    List<SelectionItem> choices_ = [];
    int i = 0;
    _templates.forEach((k, e) {
      print("_template i="+i.toString()+", k="+k.toString());
      choices_.add(SelectionItem(value: i, title: k, id: e.id));
      i++;
    });
    return choices_;
  }
}

class Style extends LinkedListEntry<Style> {
  int id;
  String _templateName;
  double _fontSize;
  bool _isBold;
  String _fontFamily;
  Color _bgColor;
  static int _nextId = 0;

  Style(this._templateName) {
    _fontSize = ScreenUtil.getDp(C.plain_text_node_font_size_100p);
    _isBold = false;
    _fontFamily = "";
    _bgColor = Colors.blue;

    id = _nextId++;
    if (_templateName != null) {
      StyleManager().addStyle(_templateName, this);
    }
  }

  static Style styleForWidget(NodeWidgetBase widget) {
    if (widget == null) {
      return Settings().defaultStyle();
    }
    return widget.createStyleIfNotExists();
  }

  String name() {
    return _templateName;
  }

  void setName(template_name) {
    StyleManager().addStyle(template_name, this);
  }

  void setFontSize(double fontSize) {
    _fontSize = fontSize;
  }

  double fontSize() {
    return _fontSize;
  }

  void setFontWeight(bool isBold) {
    _isBold = isBold;
  }

  bool fontIsBold() {
    return _isBold;
  }

  FontWeight fontWeight() {
    return _isBold ? FontWeight.bold : FontWeight.normal;
  }

  void setFontFamily(familyName) {
    _fontFamily = familyName;

  }

  String fontFamily() {
    return _fontFamily;
  }

  void setBackgroundColor(color) {
    _bgColor = color;
  }

  Color bgColor() {
    return _bgColor;
  }
}