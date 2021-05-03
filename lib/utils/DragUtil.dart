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

  Offset diff() {
    return lastEndOffset - lastStartOffset;
  }

  void moveToPostion(Offset diff) {
    print("DragUtil moveByDIff" + diff.dx.toString()+","+diff.dy.toString());
    moveOffset = moveOffset + diff;
    idleOffset = moveOffset;
  }

  void onPanStart(detail) {
    print("Drag onPanStart");
    lastStartOffset = detail.globalPosition;
  }

  void onPanUpdate(detail) {
    print("Drag onPanUpdate");
    moveOffset = detail.globalPosition - lastStartOffset + idleOffset;
    lastEndOffset = detail.globalPosition;
  }

  void onPanEnd(detail) {
    print("Drag onPanEnd");
    idleOffset = moveOffset;
  }

  void clear() {
    idleOffset = Offset(0, 0);
  }
}