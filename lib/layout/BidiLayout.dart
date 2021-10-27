import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:FlutterMind/MindMap.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/TreeNode.dart';
import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:FlutterMind/utils/base.dart';
import 'package:FlutterMind/widgets/NodeWidget.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:flutter/material.dart';

import '../MapController.dart';
import 'LayoutObject.dart';
import 'LayoutController.dart';

class BidiLayout extends LayoutObject {

  double GAP = 10;
  double layout_height = 0;
  double children_layout_height = 0;
  double right_layout_height = 0;
  double left_layout_height = 0;


  BidiLayout(widget) : super(widget) {
  }


  void relayout() {
    resize();
    Log.e("relayout begin...");
    if (widget.isRoot) {
      relayoutByDirection(Direction.left, widget.left, left_layout_height);
      relayoutByDirection(Direction.right, widget.right, right_layout_height);
    } else {
      relayoutByDirection(widget.direction, widget.children, layout_height);
    }
    Log.e("relayout end...");
    LayoutController().notifyMapRectChanged();
  }

  void relayoutByDirection(Direction direction, List<TreeNode> layout_list, double layout_height) {
    if (layout_list == null || layout_list.length == 0) {
      print("relayoutByDirection layout_list is null");
      return;
    }

    Offset offset = widget.center();
    double distance = Settings().distance;
    double w = widget.layout.width;
    Log.e("relayoutByDirection " + direction.toString()+", layout_height:"+layout_height.toString()+", w:"+w.toString());

    offset = offset.translate( direction == Direction.right ? distance + w/ 2 : -distance-w/2, -layout_height/2);

    layout_list.forEach((node) {
      BidiLayout obj = node.layout;
      double h = (obj.layout_height - obj.height) / 2;

      // offset = offset.translate(direction == Side.right ? 0 : l.width, 0);
      // Log.e("relayoutByDirection  layout width: " + l.width.toString());


      obj.moveToPosition(offset.translate(direction == Direction.right ? 0 : -obj.width, h));

      Log.e("relayoutByDirection next, child layout: "
      + obj.layout_height.toString()+", child id:"+ obj.widget.id.toString()+", child height: " + obj.height.toString()
      +", self height:" + height.toString() +" ,  self id = " + widget.id.toString());

      offset = offset.translate(0, obj.layout_height);

      // layout children
      if (node.attached) {
        obj.relayoutByDirection(direction, node.children, obj.children_layout_height);
      }
    });
    dirty = false;
  }

  void resize() {
    Log.e("resize begin...");
    if (widget.isRoot) {
      left_layout_height = 0;
      widget.left?.forEach((node) {
        BidiLayout o = node.layout;
        if (o != null) {

          Log.e("resize dirty =  " + o.dirty.toString()+", this="+o.hashCode.toString());

          if (o.dirty) {
            o.resize();
          }

          left_layout_height += o.layout_height;
        }
      });
      Log.e("resize left layout height = " + left_layout_height.toString());
      right_layout_height = 0;
      widget.right?.forEach((node) {
        BidiLayout o = node.layout;
        if(o.dirty) {
          o.resize();
        }
        right_layout_height += o.layout_height;
      });
      Log.e("resize right layout height = " + right_layout_height.toString());
    } else {
      children_layout_height = 0;
      if (widget.children != null && widget.children.length > 0 && widget.attached) {
        widget.children.forEach((node) {
          BidiLayout o = node.layout;
          if(o.dirty) {
            o.resize();
          }
          children_layout_height += o.layout_height;
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
}