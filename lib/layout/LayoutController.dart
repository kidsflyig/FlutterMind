import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/widgets/RootNodeWidget.dart';

import '../Document.dart';
import '../Settings.dart';
import 'BidiLayout.dart';
import 'Layout.dart';
import 'StarLayout.dart';

class LayoutController {
  LayoutController._privateConstructor();

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
}