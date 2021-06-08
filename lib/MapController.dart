import 'dart:ui';

import 'package:FlutterMind/utils/Utils.dart';

import 'MindMap.dart';
import 'Edge.dart';
import 'MindMapView.dart';
import 'Node.dart';
import 'nodewidget/NodeWidget.dart';
import 'nodewidget/NodeWidgetBase.dart';

class MapController {
  MapController._privateConstructor();

  static MapController _instance = null;

  factory MapController() {
    if (_instance == null) {
      _instance = MapController._privateConstructor();
    }
    return _instance;
  }

  static Map<MindMap, MapController> controllers;
  MindMapView mind_map_view_;
  Map<Node, Edge> edges;
  NodeWidgetBase selected;

  static of(MindMap doc) {
    if (controllers == null) {
      controllers = Map<MindMap, MapController>();
    }
    if (controllers[doc] == null) {
      controllers[doc] = new MapController();
    }

    return controllers[doc];
  }

  void setMindMapView(view) {
    mind_map_view_ = view;
  }

  void selectNode(NodeWidgetBase nw) {
    print("selectNode");
    if (selected != null) {
      selected.setSelected(false);
    }
    selected = nw;
    nw.setSelected(true);
  }

  Offset Center() {
    return Offset(Utils.screenSize().width * 3 / 2, Utils.screenSize().height * 3 / 2);
  }

  Node addNodeFromJson(Map<String, dynamic> data, Node p) {
    if (data == null) {
      return null;
    }
    var n = null;

    String title = data["title"];
    if (p == null) {
      n = new Node(NodeType.rootNode);
      n.left = Center().dx;
      n.top = Center().dy;
    } else {
      n = new TextNode();
      n.data = title;
      p.addChild(n);
    }
    // n.left = CalcNewLocation(n).dx;
    // n.top = CalcNewLocation(n).dy;
    List<dynamic> children = data["children"];
    if (children != null) {
      children.forEach((v) {
        Map<String, dynamic> c = v;
        addNodeFromJson(c, n);
      });
    }
    return n;
  }

  Map<String, dynamic> createJsonFromNode(Node node) {
    if (node == null) {
      return null;
    }

    Map<String, dynamic> result = new Map<String, dynamic>();
    if (node.type == NodeType.plainText) {
      TextNode tn = node;
      result["title"] = tn.data;
    } else if (node.type == NodeType.rootNode) {
      result["title"] = "root";
    }

    if (node.children != null) {
      List<dynamic> children = new List<dynamic>();
      node.children.forEach((e) {
        Map<String, dynamic> v = createJsonFromNode(e);
        children.add(v);
      });
      result["children"] = children;
    }

    return result;
  }

  void rebuild() {
    mind_map_view_.foreground.rebuild();
  }

  void addNode(Node node) {
    print("addNode");
    var n = new TextNode();
    if (node != null) {
      node.addChild(n);
    }
    mind_map_view_.foreground.addNode(n);
  }

  void removeNode(Node node) {
    mind_map_view_.foreground.removeNode(node);
    if (selected == node.widget()) {
      selected = null;
    }
    node.removeFromParent();
  }
}