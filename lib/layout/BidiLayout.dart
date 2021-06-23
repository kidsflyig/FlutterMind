import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:FlutterMind/MindMap.dart';
import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/widgets/NodeWidget.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/widgets/PlaceHolderWidget.dart';
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
  double distance = 200;
  Side direction;
  double layout_height = 0;
  double right_layout_height = 0;
  double left_layout_height = 0;
  bool is_floating = false;
  NodeWidgetBase floating;
  PlaceHolderWidget holder;

  BidiLayout(widget) : super(widget) {
    left = new List<Layout>();
    right = new List<Layout>();
  }

  BidiLayout ToBidiLayout(Layout l) {
    if (l is BidiLayout) {
      return l;
    }

    return null;
  }

  void relayout() {
    resize();
    if (parent == null) {
      relayoutByDirection(Side.left, left, left_layout_height);
      relayoutByDirection(Side.right, right, right_layout_height);
    } else {
      relayoutByDirection(direction, children, layout_height);
    }
  }

  void relayoutByDirection(Side direction, List<Layout> layout_list, double layout_height) {
    Log.e("relayoutByDirection " + direction.toString());
    if (layout_list == null) {
      print("relayoutByDirection layout_list is null");
      return;
    }
    Offset offset = NodeWidgetBase.ToNodeWidgetBase(widget).center();
    offset = offset.translate( direction == Side.right ? distance : -distance, -layout_height/2);

    layout_list.forEach((layout) {
      BidiLayout l = layout;
      double h = (l.layout_height - layout.height) / 2;
      layout.moveToPosition(offset.translate(0, h));
      MapController().update(layout.widget.node);

      Log.e("relayoutByDirection " + h.toString()+"," + l.layout_height.toString()+" , "+layout.height.toString());
      offset = offset.translate(direction == Side.right ? 0 : l.width, l.layout_height);
      // layout children
      l.relayoutByDirection(direction, l.children, l.layout_height);
    });
    dirty = false;
  }

  void resize() {
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
      layout_height = 0;
      if (children != null && children.length > 0) {
        children.forEach((layout) {
          if(layout.dirty) {
            layout.resize();
          }
          layout_height += ToBidiLayout(layout).layout_height;
        });
        Log.e("resize middle node layout height = " + layout_height.toString());
      } else {
        layout_height = height + GAP;
        Log.e("resize leaf layout height = " + layout_height.toString());
      }
    }
  }

  void addChild(Layout child, {Direction direction = Direction.auto}) {
    if (parent != null) {
      ToBidiLayout(child).direction = this.direction;
      super.addChild(child, direction:direction);
      return;
    }

    if (direction == Direction.auto) {
      if (right.length > left.length) {
        ToBidiLayout(child).direction = Side.left;
        left.add(child);
      } else {
        ToBidiLayout(child).direction = Side.right;
        right.add(child);
      }
    } else {

      if (direction == Direction.left) {
        ToBidiLayout(child).direction = Side.left;
        left.add(child);
      } else if (direction == Direction.right) {
        ToBidiLayout(child).direction = Side.right;
        right.add(child);
      }
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

  void onPanStart(detail) {
    super.onPanStart(detail);
    if (floating == null) {
      floating = widget.clone();
      NodeWidget.cast(floating).setColor(Colors.blue);
      MapController().mind_map_view_.foreground.addWidget(floating);
    }
    widget.setAlpha(155);
  }

  void _removeHolder() {
    if (holder != null) {
      MapController().mind_map_view_.foreground.removeWidget(holder);
      holder = null;
    }
  }

  void onPanUpdate(detail) {
    if (floating == null) {
      super.onPanUpdate(detail);
      HitTestResult res = HitTestResult();
      hittest(res, LayoutController().root, this, Rect.fromLTWH(x, y, width, height));
      if (res.hit) {
        if (holder == null) {
          Log.e("moveTo1 " + this.hashCode.toString());

          holder = PlaceHolderWidget(res.widget, res.target, res.direction);
          MapController().mind_map_view_.foreground.addWidget(holder);
        } else {
          holder.update(res.target, res.direction);
        }
      } else {
        Log.e("moveTo1 _removeHolder");
        _removeHolder();
      }
    } else {
      Log.e("moveTo2 " + this.hashCode.toString()+" , " + floating.hashCode.toString());
      floating.onPanUpdate(detail);
    }
  }

  void onPanEnd(detail) {
    if (floating == null) {
      super.onPanEnd(detail);
    } else {
      floating.onPanEnd(detail);
      PlaceHolderWidget holder = ToBidiLayout(floating.layout).holder;
      if (holder != null) {
        // widget.moveTo(holder);
        Log.e("test begin move node");
        MapController().moveTo(widget.node, holder.widget.node, holder.direction);
      } else {
        Log.e("moveTo failed, holder is null for "
         + floating.layout.hashCode.toString()+". this:"+this.hashCode.toString());
      }


      ToBidiLayout(floating.layout)._removeHolder();

      MapController().mind_map_view_.foreground.removeWidget(floating);
      floating = null;
      widget.setAlpha(255);
    }
  }

  void hittest(HitTestResult res, Layout cur, Layout floating, Rect floating_rect) {
    if (cur == null || cur == floating || ToBidiLayout(cur).floating != null) {
      Log.e("hit invalid");
      return;
    }

    int score = 0;
    Rect nwr = Rect.fromLTWH(cur.x, cur.y, cur.width, cur.height);
    Rect intr = nwr.intersect(floating_rect);
    if (!intr.isEmpty) {
      if (!res.hit) {
        res.hit = true;
      }
      double left_div = nwr.width / 3;
      double right_div = nwr.width * 2 / 3;
      double top_div = nwr.height / 3;
      double bottom_div = nwr.height * 2 / 3;
      Log.i("[hittest] hit rect " + nwr.toString()+","+floating_rect.toString()+", "+ intr.toString());

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
      children.forEach((e) {
        hittest(res, e, floating, floating_rect);
      });
    }
  }
}