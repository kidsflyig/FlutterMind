import 'dart:ui';

import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/StyleManager.dart';
import 'package:FlutterMind/dialogs/StyleSelector.dart';
import 'package:FlutterMind/operations/History.dart';
import 'package:FlutterMind/operations/OpCreateNew.dart';
import 'package:FlutterMind/operations/OpDeleteFile.dart';
import 'package:FlutterMind/operations/OpLoadFromFile.dart';
import 'package:FlutterMind/operations/OpSetScale.dart';
import 'package:FlutterMind/operations/OpWriteToFile.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/dialogs/StyleEditorDialog.dart';

import 'MindMap.dart';
import 'Edge.dart';
import 'MindMapView.dart';
import 'Node.dart';
import 'operations/OpCenterlize.dart';
import 'operations/OpSetBgColor.dart';
import 'operations/OpSetEdgeColor.dart';
import 'operations/OpSetNodeBgColor.dart';
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

  NodeWidgetBase cutted;
  bool _paiting = false;
  String file_name;

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

    if (cutted != null) {
      showPastePopup();
    }
  }

  void hidePopup() {
    mind_map_view_.foreground.hidePopup();
  }

  void hideInputPanel() {
    mind_map_view_.foreground.hideInputPanel();
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

    mind_map_view_.foreground.centerlize();
  }

  void Clear() {
    mind_map_view_.foreground.Clear();
  }

  void relayout() {
    MindMap map = MindMap();
    dynamic w = map.root.widget();
    w.relayout();
  }

  void _repaint(Node n) {
    NodeWidgetBase w = n.widget();
    w.repaint();
    n.children?.forEach((Node v) {
      NodeWidgetBase w = v.widget();
      w.repaint();
      _repaint(v);
    });
  }

  void repaint() {
    if (_paiting) {
      Log.e("repaint in progress");
      return;
    }
    _paiting = true;
    Future(() {
      Log.e("repainting");
      MindMap map = MindMap();
      _repaint(map.root);
      _paiting = false;
    });
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
      MapController().repaint();
    }
    mind_map_view_.foreground.addNode(n);

    mind_map_view_.updatePreview();
  }

  NodeWidgetBase getSelected() {
    return selected;
  }

  void cut() {
    Log.e("cut " + selected?.toString());
    cutted = selected;
  }

  void showPastePopup() {
    Log.e("showPastePopup " + selected?.toString());
    mind_map_view_.foreground.showPastePopup(selected, null);
  }

  void paste(Direction direction) {
    Log.e("paste " + direction.toString());
    hidePopup();
    moveTo(cutted.node, selected.node, direction);
    cutted = null;
  }

  void centerlize() {
    OpCenterlize(mind_map_view_.foreground, "居中").doAction();
  }

  void moveTo(Node from, Node to, Direction direction) {
    if (direction == Direction.left || direction == Direction.right) {
      to.addChild(from, direction:direction);
    } else if (direction == Direction.top) {
      to.parent.insertBefore(from, to);
    } else if (direction == Direction.bottom) {
      to.parent.insertAfter(from, to);
    }

    dynamic w = to.root().widget();
    w.relayout();
    MapController().repaint();
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
    MapController().repaint();
  }

  // void update(Node node) {
  //   dynamic w = node.widget();
  //   w.repaint();

  //   if (node.to_edges != null) {
  //     node.to_edges.forEach((e) {
  //       dynamic w = e.widget();
  //       w.update(null);
  //     });
  //   }
  // }

  void input(Node node, Function cb) {
    mind_map_view_.foreground.showInput(node.widget(), cb);
  }

  void setFontSize(double size, NodeWidgetBase widget) {
    Style template = Style.styleForWidget(widget);
    template.setFontSize(size);
    repaint();
  }

  void setFontWeight(bool is_bold, NodeWidgetBase widget) {
    Style template = Style.styleForWidget(widget);
    template.setFontWeight(is_bold);
    repaint();
  }

  void setFontFamily(String font_family, NodeWidgetBase widget) {
    Style template = Style.styleForWidget(widget);
    template.setFontFamily(font_family);
    repaint();
  }

  void setScaleLevel(double scale_level) {
    Log.e("setScaleLevel " + scale_level.toString());
    OpSetScale.create(scale_level).doAction();
  }

  void repaintBackground() {
    mind_map_view_.foreground.repaint();
  }

  void setBackgroundColor(Color c) {
    OpSetBgColor.create(c).doAction();
  }

  void setBackgroundColorForWidget(Color c, NodeWidgetBase widget) {
    OpSetNodeBgColor.create(c, widget).doAction();
  }

  void setEdgeColor(Color c) {
    OpSetEdgeColor.create(c).doAction();
  }

  void detachSelctedNode() {
    if (selected.node.children_attached) {
      selected.node.detach();
      selected.detach();
    } else {
      selected.node.attach();
      selected.attach();
    }
    // selected.node.detach();
    mind_map_view_.foreground.rebuild();
  }

  void undo() {
    Log.e("MapController undo");
    History().pop();
  }

  void redo() {
    Log.e("MapController redo");
    History().restore();
  }

  void popupStyleEditorForSelected(context) {
    print("selected = " + selected.toString());
    StyleEditorDialog.show(context, selected).then((value){
      // created or closed?
    });
  }

  void showStyleSelector(context) {
    StyleSelectorDialog.showStyleSelector(context);
  }

  void saveAsTemplate(NodeWidgetBase widget, name) {
    Log.e("saveAsTemplate");
    Style style = Style.styleForWidget(widget);
    style.setName(name);
  }

  Offset posInScreen(Offset pos) {
    return pos.translate(mind_map_view_.foreground.left_, mind_map_view_.foreground.top_);
  }
  void createNew() {
    OpCreateNew("New").doAction();
    file_name = "";
  }

  void load(path) {
    OpLoadFromFile(path).doAction();
    file_name = path;
  }

  void save() {
    MindMap map = MindMap();
    OpWriteToFile(file_name, map.root.label).doAction();
  }

  void delete(String path) {
    MindMap map = MindMap();
    OpDeleteFile(path).doAction();
    if (path == file_name) {
      MindMap map = MindMap();
      map.Clear();
    }
  }
}