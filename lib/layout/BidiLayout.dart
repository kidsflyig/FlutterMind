import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:FlutterMind/MindMap.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/utils/base.dart';
import 'package:FlutterMind/widgets/NodeWidget.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:flutter/material.dart';

import '../MapController.dart';
import 'Layout.dart';
import 'LayoutController.dart';

enum Side {
  right,
  left
}

class BidiLayout extends Layout {
  List<Layout> left;
  List<Layout> right;
  double GAP = 10;
  Side direction;
  double layout_height = 0;
  double children_layout_height = 0;
  double right_layout_height = 0;
  double left_layout_height = 0;
  bool is_floating = false;
  NodeWidgetBase floating;

  BidiLayout(widget) : super(widget) {
    left = new List<Layout>();
    right = new List<Layout>();
  }

  void clear() {
    left.clear();
    right.clear();
    // super.clear();
  }

  BidiLayout ToBidiLayout(Layout l) {
    if (l is BidiLayout) {
      return l;
    }

    return null;
  }

  void relayout() {
    resize();
    Log.e("relayout begin...");
    if (parent == null) {
      relayoutByDirection(Side.left, left, left_layout_height);
      relayoutByDirection(Side.right, right, right_layout_height);
    } else {
      relayoutByDirection(direction, children, layout_height);
    }
    Log.e("relayout end...");
    LayoutController().notifyMapRectChanged();
    MapController().repaint();
  }

  void relayoutByDirection(Side direction, List<Layout> layout_list, double layout_height) {
    if (layout_list == null) {
      print("relayoutByDirection layout_list is null");
      return;
    }
    Log.e("relayoutByDirection " + direction.toString());
    Offset offset = NodeWidgetBase.ToNodeWidgetBase(widget).center();
    double distance = Settings().distance;
    double w = NodeWidgetBase.ToNodeWidgetBase(widget).width;
    offset = offset.translate( direction == Side.right ? distance + w/ 2 : -distance-w/2, -layout_height/2);

    layout_list.forEach((layout) {
      BidiLayout l = layout;
      double h = (l.layout_height - layout.height) / 2;

      // offset = offset.translate(direction == Side.right ? 0 : l.width, 0);
      // Log.e("relayoutByDirection  layout width: " + l.width.toString());

      layout.moveToPosition(offset.translate(direction == Side.right ? 0 : -l.width, h));
      // MapController().update(layout.widget.node);

      Log.e("relayoutByDirection next, child layout: "
      + l.layout_height.toString()+", child id:"+ l.widget.node.id.toString()
      +", self height:" + height.toString() +" ,  self id = " + widget.node.id.toString());

      offset = offset.translate(0, l.layout_height);
      // layout children
      if (l.attached) {
        l.relayoutByDirection(direction, l.children, l.children_layout_height);
      }
      // offset = offset.translate(direction == Side.right ? 0 : -l.width, 0);
    });
    dirty = false;
  }

  void resize() {
    Log.e("resize begin...");
    if (parent == null) {
      left_layout_height = 0;
      left?.forEach((layout) {
        if (layout.dirty) {
          layout.resize();
        }

        left_layout_height += ToBidiLayout(layout).layout_height;
      });
      Log.e("resize left layout height = " + left_layout_height.toString());
      right_layout_height = 0;
      right?.forEach((layout) {
        if(layout.dirty) {
          layout.resize();
        }
        right_layout_height += ToBidiLayout(layout).layout_height;
      });
      Log.e("resize right layout height = " + right_layout_height.toString());
    } else {
      children_layout_height = 0;
      if (children != null && children.length > 0 && attached) {
        children.forEach((layout) {
          if(layout.dirty) {
            layout.resize();
          }
          children_layout_height += ToBidiLayout(layout).layout_height;
        });
        layout_height = children_layout_height > height ? children_layout_height : height;
        Log.e("resize middle node layout height = " + layout_height.toString());
      } else {
        layout_height = height + GAP;
        Log.e("resize leaf layout height = " + layout_height.toString());
      }
    }
    Log.e("resize end...");
  }

  void addChild(Layout child, Direction direction) {
    if (parent != null) {
      ToBidiLayout(child).direction = this.direction;
      super.addChild(child, direction);
      return;
    }

    if (direction == Direction.left) {
      ToBidiLayout(child).direction = Side.left;
      left.add(child);
    } else if (direction == Direction.right) {
      ToBidiLayout(child).direction = Side.right;
      right.add(child);
    }

    child.parent = this;
  }

  void removeChild(Layout child) {
    Log.e("BidiLayout removeChild");
    if (parent == null) {
      if (ToBidiLayout(child).direction == Side.left) {
        left.remove(child);
      } else {
        right.remove(child);
      }
      child.parent = null;
    } else {
      super.removeChild(child);
    }
  }

  void insertBefore(Layout src, Layout target) {
    if (parent == null) {
      src.parent = this;
      int idx = right.indexOf(target);
      if (idx >= 0) {
        right.insert(idx, src);
        return;
      }
      idx = left.indexOf(target);
      if (idx >=0) {
        left.insert(idx, src);
      }
    } else {
      super.insertBefore(src, target);
    }
  }

  void insertAfter(Layout src, Layout target) {
    if (parent == null) {
      src.parent = this;
      int idx = right.indexOf(target);
      if (idx >= 0) {
        right.insert(idx + 1, src);
        ToBidiLayout(src).direction = Side.right;
        return;
      }
      idx = left.indexOf(target);
      if (idx >=0) {
        left.insert(idx + 1, src);
        ToBidiLayout(src).direction = Side.left;
      }
    } else {
      super.insertAfter(src, target);
      ToBidiLayout(src).direction = ToBidiLayout(target).direction;
    }
  }

  @override
  void moveToPosition(Offset offset) {
    super.moveToPosition(offset);
    LayoutController().updateMapRect(
      Rect.fromLTWH(drag_.moveOffset.dx, drag_.moveOffset.dy, width, height));
  }

  @override
  void moveByOffset(Offset offset) {
    super.moveByOffset(offset);

    LayoutController().updateMapRect(
      Rect.fromLTWH(drag_.moveOffset.dx, drag_.moveOffset.dy, width, height));
  }

  void hittest(HitTestResult res, Layout cur, Layout floating, Rect floating_rect) {
    if (cur == null || cur == floating || ToBidiLayout(cur).floating != null) {
      Log.i("hit invalid");
      return;
    }
    int score = 0;
    Rect nwr = Rect.fromLTWH(cur.x, cur.y, cur.width, cur.height);
    Rect intr = nwr.intersect(floating_rect);

    Log.i("[hittest] hit rect: cur layout size=" + nwr.toString()+" id=" + cur.widget.node.id.toString() +", float size="+floating_rect.toString()+
        ", intersect="+ intr.toString());

    if (!intr.isEmpty) {
      if (!res.hit) {
        res.hit = true;
      }
      double left_div = nwr.width / 3;
      double right_div = nwr.width * 2 / 3;
      double top_div = nwr.height / 3;
      double bottom_div = nwr.height * 2 / 3;

      if (intr.left - nwr.left > right_div) {
        res.direction = Direction.right;
      } else if (nwr.right - intr.right > right_div) {
        res.direction = Direction.left;
      } else if (intr.top - nwr.top > nwr.height / 2) {
        res.direction = Direction.bottom;
      } else {
        res.direction = Direction.top;
      }
      score = (intr.width * intr.height).toInt();

      if (score > res.score) {
        res.score = score;
        res.target = nwr;
        res.widget = cur.widget;
      }
    }

    // walk through other layout nodes
    if (cur.parent == null) {
      if (floating_rect.left > (cur.x + cur.width)) {
        ToBidiLayout(cur).right.forEach((e) {
          hittest(res, e, floating, floating_rect);
        });
      } else if ((floating_rect.left + floating_rect.width) < cur.x) {
        ToBidiLayout(cur).left.forEach((e) {
          hittest(res, e, floating, floating_rect);
        });
      }
    } else if (
      (floating_rect.left > cur.x && ToBidiLayout(cur).direction == Side.right) ||
      (floating_rect.left < cur.x && ToBidiLayout(cur).direction == Side.left)) {

      cur.children.forEach((e) {
        hittest(res, e, floating, floating_rect);
      });
    }
  }
}