import 'dart:collection';
import 'dart:ui';

import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/third_party/smartselection/src/model/choice_item.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:flutter/material.dart';

class Style extends LinkedListEntry<Style> {
  static Map<String, Style> _templates = Map<String, Style>();
  static List<S2Choice<int>> _choices;

  String _templateName;
  double _fontSize;
  bool _isBold;
  String _fontFamily;
  Color _bgColor;

  Style(this._templateName) {
    _fontSize = ScreenUtil.getDp(plain_text_node_font_size_100p);
    _isBold = false;
    _fontFamily = "";
    _bgColor = Colors.blue;

    if (_templateName != null) {
      _templates[_templateName] = this;
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
    if (template_name == null) {
      return;
    }
    if (_templateName != null) {
      _templates[_templateName] = null;
    }
    _templates[template_name] = this;
  }

  static List<S2Choice<int>> choices() {
    List<S2Choice<int>> choices_ = [];
    int i = 0;
    _templates.forEach((k, e) {
      choices_.add(S2Choice<int>(value: i, title: k));
    });
    return choices_;
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