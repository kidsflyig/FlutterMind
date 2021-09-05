import 'dart:collection';

import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/widgets/RootNodeWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'MindMapView.dart';
import 'layout/Layout.dart';
import 'MindMap.dart';
import 'Edge.dart';
import 'MapController.dart';
import 'widgets/NodeWidget.dart';

enum NodeType {
  rootNode,
  plainText,
  image
}

class Node {
  int id;
  String label = "";
  NodeType type;
  Layout layout;

  List<Node> children;
  HashSet<Edge> from_edges;
  HashSet<Edge> to_edges;
  MindMap map;
  Node parent;
  bool attached = true;
  bool children_attached = true;
  // double left = 0;
  // double top = 0;
  GlobalKey key;
  NodeWidgetBase _widget;
  Node(this.type) {
    children = List();
    from_edges = HashSet();
    to_edges = HashSet();
    id = nextID();
  }

  static Node create(type) {
    if (type == NodeType.plainText) {
      return TextNode();
    } else {
      return Node(NodeType.rootNode);
    }
  }

  Node clone() {
    Node n = Node.create(type);
    return n;
  }

  Node.fromId(this.type, int id) {
    this.id = id;
  }

  static int _next_id = 0;
  static int nextID() {
    return ++_next_id;
  }

  addChild(Node node, {Direction direction = Direction.auto}) {
    print("Node addChild");
    if (node.parent != null) {
      if(node.parent != this) {
        node.removeFromParent(cb:(e) {
          e.update(this, node);
          Log.e("modify edge " + this.id.toString()+":"+node.id.toString());
        });
      } else {
        node.removeFromParent();
      }
    } else {
      new Edge(this, node);
    }
    node.parent = this;

    if (node.map == null && map != null) {
      node.map = map;
    }
    children.add(node);

     widget(); // createWidget
    _widget.addChild(node, direction:direction);
  }

  void insertBefore(Node n, Node target) {
    n.removeFromParent(cb:(e) {
      e.update(this, n);
      Log.e("insertBefore modify edge " + this.id.toString()+":"+n.id.toString());
    });
    n.parent = this;

    int idx = children.indexOf(target);
    Log.e("Node insertBefore "+n.id.toString()+" , " + target.id.toString()+", idx="+idx.toString());
    children.insert(idx, n);
    _widget.insertBefore(n, target);
  }

  void insertAfter(Node n, Node target) {
    n.removeFromParent(cb:(e) {
      e.update(this, n);
      Log.e("insertAfter modify edge " + this.id.toString()+":"+n.id.toString());
    });
    n.parent = this;

    int idx = children.indexOf(target);
    Log.e("Node insertAfter "+n.id.toString()+" , " + target.id.toString()+", idx="+idx.toString());
    children.insert(idx + 1, n);
    _widget.insertAfter(n, target);
  }

  void removeNode(Node node, {cb:null}) {
    print("removeNode1");
    if (children == null)
      return;

    children.remove(node);
    print("removeNode2");
    if (from_edges != null) {
      Edge e = from_edges.firstWhere((e) => (e.to == node), orElse: () => null);
      if (e != null) {
        from_edges.remove(e);
        if (cb != null) cb(e);
      }
    }
  }

  void removeFromParent({cb:null}) {
    print("removeFromParent1");
    if (parent == null)
      return;
    print("removeFromParent2");
    _widget.removeFromParent();
    parent.removeNode(this, cb:cb);
  }

  void addEdge(Edge e, bool from) {
    Log.i("Node addEdge");
    if (from) {
      from_edges.add(e);
    } else {
      to_edges.add(e);
    }

    print(this.hashCode.toString()+ ", " +e.hashCode.toString());
  }

  void attach() {
    children_attached = true;
    children.forEach((v) {
      v.attached = true;
      v.attach();
    });
  }

  void detach() {
    children_attached = false;
    children.forEach((v) {
      v.attached = false;
      v.detach();
    });
  }

  Widget widget() {
    if (_widget == null) {
      _widget = NodeWidgetBase.create(this);
      if (type == NodeType.rootNode) {
        print("create NodeWidget2 ");
        RootNodeWidget w = _widget;
        w.moveToPostion(MindMapView.Center());
      }
    }

    return _widget;
  }

  void Clear() {
    children.clear();
    from_edges.clear();
    _widget = null;
  }

  Node root() {
    if (map == null) {
      map = MindMap();
    }
    return map.root;
  }

  void selected(selected) {
    // Node prev = map.selectedNode();
    // prev.selected()
  }

  // void moveToPosition(Offset offset) {
  //   left = offset.dx;
  //   top = offset.dy;
  //   if (_widget is NodeWidgetBase) {
  //     (_widget as NodeWidgetBase).moveToPosition(offset);
  //   }
  // }
}

class TextNode extends Node {
  String data;
  TextNode():super(NodeType.plainText);
}