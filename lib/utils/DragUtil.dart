import 'dart:ui';

import 'package:flutter/material.dart';

class DragUtil {

  //静止状态下的offset
  Offset idleOffset = Offset(0, 0);
  //本次移动的offset
  Offset moveOffset = Offset(0, 0);
  //最后一次down事件的offset
  Offset lastStartOffset = Offset(0, 0);
  Offset lastEndOffset = Offset(0, 0);
  Offset delta = Offset(0, 0);

  DragUtil clone() {
    DragUtil drag = new DragUtil();
    drag.idleOffset = idleOffset;
    drag.moveOffset = moveOffset;
    drag.lastStartOffset = lastStartOffset;
    drag.lastEndOffset = lastEndOffset;
    drag.delta = delta;
    return drag;
  }

  void moveToPosition(Offset dst) {
    print("DragUtil move to position" + dst.dx.toString()+","+dst.dy.toString());
    moveOffset = dst;
    idleOffset = moveOffset;
  }

  void moveByOffset(Offset diff) {
    print("DragUtil moveByDIff" + diff.dx.toString()+","+diff.dy.toString());
    moveOffset = moveOffset + diff;
    idleOffset = moveOffset;
  }

  void onPanStart(detail) {
    Offset offset;
    if (detail is DragStartDetails) {
      offset = detail.globalPosition;
    } else {
      offset = detail;
    }
    print("Drag onPanStart " + offset.toString());
    lastStartOffset = offset;
    lastEndOffset = lastStartOffset;
  }

  void onPanUpdate(detail) {
    Offset offset;
    if (detail is DragUpdateDetails) {
      offset = detail.globalPosition;
    } else {
      offset = detail;
    }
    print("Drag onPanUpdate " + offset.toString());
    moveOffset = offset - lastStartOffset + idleOffset;
    delta = offset - lastEndOffset;
    lastEndOffset = offset;
  }

  void onPanEnd(DragEndDetails detail) {
    print("Drag onPanEnd");
    idleOffset = moveOffset;
  }

  void clear() {
    idleOffset = Offset(0, 0);
  }
}