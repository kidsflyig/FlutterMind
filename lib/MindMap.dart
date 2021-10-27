import 'dart:collection';
import 'dart:convert';

import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/TreeNode.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/widgets/Edge.dart';
import 'package:flutter/widgets.dart';

import 'MapController.dart';
// import 'Node.dart';

class MindMap {
  MindMap._privateConstructor();

  static MindMap _instance = null;

  factory MindMap() {
    if (_instance == null) {
      _instance = MindMap._privateConstructor();
    }
    return _instance;
  }

  TreeNode root;
  String file_name;

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

  void Clear() {
    if (root == null) {
      root = TreeNode.create(NodeType.rootNode);
    } else {
      root.Clear();
    }
    MapController().rebuild();
  }

  // GenerateNodes() {
  //   root = new Node(NodeType.rootNode);
  //   root.map = this;
  //   // root.left = 100;
  //   // root.top = 100;
  //   var textNode = Node.create(NodeType.plainText);
  //   // textNode.left = 200;
  //   // textNode.top = 200;
  //   root.addChild(textNode, root.direction);

  //   var textNode1 = Node.create(NodeType.plainText);
  //   // textNode1.left = 300;
  //   // textNode1.top = 300;
  //   root.addChild(textNode1, root.direction);
  // }

  GatherNodeWidgets(TreeNode node, List<Widget> list) {
    if (node.attached) {
      list.add(node.widget());
    }
    Log.e("GatherNodeWidgets " + node.id.toString()+", " + node.parent?.id.toString());
    if (node.children != null) {
      node.children.forEach((e) => GatherNodeWidgets(e, list));
    }
  }

  GatherEdgeWidgets(TreeNode node, List<Widget> list) {
    HashSet<Edge> edges = node.from_edges;
    if (edges != null) {
      edges.forEach((e) {

        print("GatherEdgeWidgets " + e.hashCode.toString());
        if (e.to.attached) {
          list.insert(0, e);
        }
      });
    }

    if (node.children != null) {
      node.children.forEach((e) => GatherEdgeWidgets(e, list));
    }
  }
}