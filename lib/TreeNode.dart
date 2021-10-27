import 'dart:collection';

import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/utils/base.dart';
import 'package:FlutterMind/widgets/Edge.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/widgets/RootNodeWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'MindMapView.dart';
import 'layout/LayoutObject.dart';
import 'MindMap.dart';
import 'MapController.dart';
import 'widgets/NodeWidget.dart';

enum NodeType {
  rootNode,
  plainText,
  image
}

mixin TreeNode {
  int id = nextID();
  String label = "";
  NodeType type;

  List<TreeNode> children = List();
  List<TreeNode> left = List();
  List<TreeNode> right = List();

  HashSet<Edge> from_edges = HashSet();
  HashSet<Edge> to_edges = HashSet();
  MindMap map;
  TreeNode parent;
  bool attached = true;
  bool children_attached = true;
  // double left = 0;
  // double top = 0;
  GlobalKey key;
  LayoutObject layout;
  Direction direction = Direction.left;

  // TreeNode(this.type) {
  //   children = List();
  //   from_edges = HashSet();
  //   to_edges = HashSet();
  //   id = nextID();
  //   Log.e("new node id = " + id.toString());
  // }

  static TreeNode create(type) {
    var key = UniqueKey();
    Log.e("TreeNode create key="+key.hashCode.toString());
    if (type == NodeType.plainText) {
      return NodeWidget(key:key);
    } else if (type == NodeType.rootNode) {
      RootNodeWidget w = RootNodeWidget(key:key);
      w.moveToPostion(MindMapView.Center());
      return w;
    }
    return null;
  }

  NodeWidgetBase widget() {
    NodeWidgetBase w = this;
    return w;
  }

  TreeNode clone() {
    TreeNode n = TreeNode.create(type);
    n.label = label;
    return n;
  }

  // TreeNode.fromId(this.type, int id) {
  //   this.id = id;
  // }

  static int _next_id = 0;
  static int nextID() {
    return ++_next_id;
  }

  bool get isRoot => parent == null;

  addChild(TreeNode node) {
    print("Node addChild1");
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
      Edge.create(this, node);
    }
    node.parent = this;

    if (node.map == null && map != null) {
      node.map = map;
    }

    Direction dir = direction;
    if (isRoot) {
      if (left.length > right.length) {
        right.add(node);
        dir = Direction.right;
      } else {
        left.add(node);
      }
    } else {
      children.add(node);
    }

    node.direction = dir;
    layout.markParentDirty();
    print("Node addChild2 " + direction.toString());
  }

  void insertBefore(TreeNode n, TreeNode target) {
    n.removeFromParent(cb:(e) {
      if (e != null) {
        e.update(this, n);
        Log.e("insertBefore modify edge " + this.id.toString()+":"+n.id.toString());
      } else {
        Edge.create(this, n);
      }
    });
    n.parent = this;

    int idx = children.indexOf(target);
    Log.e("Node insertBefore "+n.id.toString()+" , " + target.id.toString()+", idx="+idx.toString());
    children.insert(idx, n);
    layout.markParentDirty();
  }

  void insertAfter(TreeNode n, TreeNode target) {
    n.removeFromParent(cb:(e) {
      if (e != null) {
        e.update(this, n);
        Log.e("insertAfter modify edge " + this.id.toString()+":"+n.id.toString());
      } else {
        Edge.create(this, n);
      }
    });
    n.parent = this;

    int idx = children.indexOf(target);
    Log.e("Node insertAfter "+n.id.toString()+" , " + target.id.toString()+", idx="+idx.toString());
    children.insert(idx + 1, n);
    // _widget.insertAfter(n, target);
    layout.markParentDirty();
  }

  void removeNode(TreeNode node, {cb:null}) {
    print("removeNode1");
    if (isRoot) {
      left?.remove(node);
      right?.remove(node);
    } else {
      children?.remove(node);
    }
    
    if (from_edges != null) {
      Edge e = from_edges.firstWhere((e) => (e.to == node), orElse: () => null);
      if (e != null) {
        from_edges.remove(e);
        if (cb != null) cb(e);
      }
    }

    layout.markParentDirty();
  }

  void removeFromParent({cb:null}) {
    print("removeFromParent1");
    if (parent == null) {
      if (cb != null) cb(null);
      return;
    }

    print("removeFromParent2");
    parent.removeNode(this, cb:cb);

    layout.markParentDirty();
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

    layout.markParentDirty();
  }

  void detach() {
    children_attached = false;
    children.forEach((v) {
      v.attached = false;
      v.detach();
    });

    layout.markParentDirty();
  }

  // Widget widget() {
  //   if (_widget == null) {
  //     _widget = NodeWidgetBase.create(this);
  //     if (type == NodeType.rootNode) {
  //       print("create NodeWidget2 ");
  //       RootNodeWidget w = _widget;
  //       w.moveToPostion(MindMapView.Center());
  //     }
  //   }

  //   return _widget;
  // }

  void Clear() {
    children?.clear();
    left?.clear();
    right?.clear();
    from_edges?.clear();
  }

  TreeNode root() {
    if (map == null) {
      map = MindMap();
    }
    return map.root;
  }

  void selected(selected) {
    // Node prev = map.selectedNode();
    // prev.selected()
  }
}