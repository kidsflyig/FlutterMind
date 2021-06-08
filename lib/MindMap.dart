import 'dart:collection';
import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'Edge.dart';
import 'MapController.dart';
import 'Node.dart';

class MindMap {
  MindMap._privateConstructor();

  static MindMap _instance = null;

  factory MindMap() {
    if (_instance == null) {
      _instance = MindMap._privateConstructor();
    }
    return _instance;
  }

  Node root;

  fromJson(data) {
    print("NodeWidget fromJson " + data);
    Map<String, dynamic> user = json.decode(data);

    root = MapController().addNodeFromJson(user , null);
    MapController().rebuild();
  }

  String toJson() {
    Map<String, dynamic> result = MapController().createJsonFromNode(root);
    print(result.toString());
    dynamic data = json.encode(result);
    return data.toString();
  }

  GenerateNodes() {
    root = new Node(NodeType.rootNode);
    root.map = this;
    root.left = 100;
    root.top = 100;
    var textNode = new TextNode();
    textNode.left = 200;
    textNode.top = 200;
    root.addChild(textNode);

    var textNode1 = new TextNode();
    textNode1.left = 300;
    textNode1.top = 300;
    root.addChild(textNode1);
  }

  GatherNodeWidgets(Node node, List<Widget> list) {
    print("GatherNodeWidgets1");
    list.add(node.widget());
    print("GatherNodeWidgets2");
    if (node.children != null) {
      node.children.forEach((e) => GatherNodeWidgets(e, list));
    }
  }

  GatherEdgeWidgets(Node node, List<Widget> list) {
    HashSet<Edge> edges = node.from_edges;
    if (edges != null) {
      edges.forEach((e) {

        print("GatherEdgeWidgets " + e.hashCode.toString());
        list.insert(0, e.widget());
      });
    }

    if (node.children != null) {
      node.children.forEach((e) => GatherEdgeWidgets(e, list));
    }
  }
}