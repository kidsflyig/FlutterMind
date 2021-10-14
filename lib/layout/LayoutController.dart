import 'dart:ui';

import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/widgets/RootNodeWidget.dart';

import '../Document.dart';
import '../Settings.dart';
import 'BidiLayout.dart';
import 'Layout.dart';
import 'StarLayout.dart';

class LayoutControllerCient {
  void updateRect(Rect r) {}
}

class LayoutController {
  LayoutController._privateConstructor();
  Rect map_rect;
  Function _fn;
  LayoutControllerCient _client;

  static LayoutController _instance = null;

  factory LayoutController() {
    if (_instance == null) {
      _instance = LayoutController._privateConstructor();
    }
    return _instance;
  }

  Layout root;

  Layout newLayout(NodeWidgetBase w) {
    Settings s = Document().s;
    Layout l;
    if (s.mode == MapMode.bidi) {
      l = BidiLayout(w);
    } else if (s.mode == MapMode.star) {
      l = StarLayout(w);
    }

    if (w is RootNodeWidget) {
      root = l;
    }
    return l;
  }

  void setCient(LayoutControllerCient client) {
    _client = client;
  }

  void onForegroundUpdated(Function fn) {
    _fn = fn;
  }

  void notifyMapRectChanged() {
    if (_client != null) {
      _client.updateRect(map_rect);
    }
  }

  void translate(dx, dy) {
    map_rect = map_rect.translate(dx, dy);
  }

  void updateMapRect(Rect r) {
    if (map_rect == null) {
      map_rect = r;
    }
    map_rect = map_rect.expandToInclude(r);
    // if (_fn != null) {
    //   Log.e("chch before fn " + map_rect.toString());
    //   _fn(map_rect, (r) {
    //     map_rect = r;
    //   });
    //   Log.e("chch after fn " + map_rect.toString());
    // }
  }
}