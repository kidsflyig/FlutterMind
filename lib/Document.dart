import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'Edge.dart';
import 'Node.dart';

class Document {
  Document._privateConstructor();

  static Document _instance = null;

  factory Document() {
    if (_instance == null) {
      _instance = Document._privateConstructor();
    }
    return _instance;
  }

  Node root;

  fromJson(json) {

  }

  GenerateNodes() {
    root = new Node(NodeType.rootNode);
    root.document = this;
    root.left = 100;
    root.top = 100;
    var textNode = new TextNode();
    textNode.left = 200;
    textNode.top = 200;
    root.addChild(textNode);

    var textNode1 = new TextNode();
    textNode.left = 300;
    textNode.top = 300;
    root.addChild(textNode1);
  }

  GatherNodeWidgets(Node node, List<Widget> list) {
    list.add(node.widget());
    if (node.children != null) {
      node.children.forEach((e) => GatherNodeWidgets(e, list));
    }
  }

  GatherEdgeWidgets(Node node, List<Widget> list) {
    HashSet<Edge> edges = node.edges;
    if (edges != null) {
      edges.forEach((e) {
        list.insert(0, e.widget());
      });
    }

    if (node.children != null) {
      node.children.forEach((e) => GatherEdgeWidgets(e, list));
    }
  }
}