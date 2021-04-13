import 'package:flutter/material.dart';

class Utils {

static Offset position(GlobalKey key) {
  RenderBox box = key.currentContext.findRenderObject();
  Offset offset = box.localToGlobal(Offset.zero);
  return offset;
}
}