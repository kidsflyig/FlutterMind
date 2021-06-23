import 'dart:ui';

import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';

import 'MindMap.dart';
import 'Edge.dart';
import 'MindMapView.dart';
import 'Node.dart';
import 'operations/OpCenterlize.dart';
import 'utils/HitTestResult.dart';
import 'widgets/NodeWidget.dart';
import 'widgets/NodeWidgetBase.dart';

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

  Node addNodeFromJson(Map<String, dynamic> data, Node p) {
    if (data == null) {
      return null;
    }
    var n = null;

    String title = data["title"];
    if (p == null) {
      n = Node.create(NodeType.rootNode);
      // n.left = Center().dx;
      // n.top = Center().dy;
    } else {
      n = Node.create(NodeType.plainText);
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

    mind_map_view_.updatePreview();
  }

  void relayout() {
    MindMap map = MindMap();
    dynamic w = map.root.widget();
    w.relayout();
  }

  void addNodeForSelected() {
    print("addNode");
    if (selected == null) {
      return;
    }
    var n = Node.create(NodeType.plainText);
    if (selected != null ) {
      Node node = selected.node;
      node.addChild(n);
      dynamic w = node.root().widget();
      w.relayout();
    }
    mind_map_view_.foreground.addNode(n);

    mind_map_view_.updatePreview();
  }

  void centerlize() {
    OpCenterlize(mind_map_view_.foreground, "居中").doAction();
  }

  void moveTo(Node from, Node to, Direction direction) {
    Log.e("MapController Node moveTo1");
    mind_map_view_.foreground.removeNode(from);
    from.removeFromParent();

    if (direction == Direction.top) {
      Node p = to.parent;
      p?.insertBefore(from, to);
      if(p == null) {
        Log.e("parent is null");
      }
    } else if (direction == Direction.right || direction == Direction.left) {
      mind_map_view_.foreground.removeNode(from);
      from.removeFromParent();
      to.addChild(from, direction:direction);
    } else if (direction == Direction.bottom) {
      Node p = to.parent;
      p?.insertAfter(from, to);
    }

    mind_map_view_.foreground.addNode(from);
    Log.e("Node moveTo3");

    dynamic w = to.root().widget();
    w.relayout();
  }

  void removeSelctedNode() {
    if (selected == null) {
      return;
    }
    Node node = selected.node;
    mind_map_view_.foreground.removeNode(node);
    if (selected == node.widget()) {
      selected = null;
    }
    Node root = node.root();
    node.removeFromParent();

    // relayout
    dynamic w = root.widget();
    w.relayout();
  }

  void update(Node node) {
    dynamic w = node.widget();
    w.updateStatus();

    if (node.to_edges != null) {
      node.to_edges.forEach((e) {
        dynamic w = e.widget();
        w.update();
      });
    }
  }

  void input(double x, double y, Function cb) {
    mind_map_view_.foreground.showInput(x, y, cb);
  }

}