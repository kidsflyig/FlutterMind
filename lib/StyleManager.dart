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
  }

  List<SelectionItem> choices() {
    List<SelectionItem> choices_ = [];
    int i = 0;
    _templates.forEach((k, e) {
      choices_.add(SelectionItem(value: k, title: k));
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
  bool _itaic;
  bool _underline;
  String _fontFamily;
  Color _bgColor;
  Color _nodeBorderColor;
  TextAlign _align;
  static int _nextId = 0;

  Style(this._templateName) {
    _fontSize = ScreenUtil.getDp(C.plain_text_node_font_size_100p);
    _isBold = false;
    _itaic = false;
    _underline = false;
    _fontFamily = "";
    _bgColor = Colors.blue;
    _nodeBorderColor  = Colors.transparent;
    _align = TextAlign.left;

    id = _nextId++;
    if (_templateName != null) {
      StyleManager().addStyle(_templateName, this);
    }
  }

  bool isDefault() {
    return _templateName == "default";
  }

  static Style styleForWidget(NodeWidgetBase widget, bool create) {
    if (widget == null) {
      return Settings().defaultStyle();
    }
    return widget.createStyleIfNotExists(create);
  }

  String name() {
    return _templateName;
  }

  void setName(template_name) {
    _templateName = template_name;
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

  void setFontItalic(bool italic) {
    _itaic = italic;
  }

  bool fontIsItalic() {
    return _itaic;
  }

  void setFontUnderline(bool underline) {
    _underline = underline;
  }

  bool fontHasUnderline() {
    return _underline;
  }

  FontWeight fontWeight() {
    return _isBold ? FontWeight.bold : FontWeight.normal;
  }

  void setFontFamily(familyName) {
    _fontFamily = familyName;

  }

  void setTextAlign(TextAlign align) {
    _align = align;
  }

  TextAlign textAlign() {
    return _align;
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

  void setNodeBorderColor(color) {
    _nodeBorderColor = color;
  }

  Color nodeBorderColor() {
    return _nodeBorderColor;
  }

}