import 'package:FlutterMind/utils/Log.dart';

import 'Operation.dart';

class History {
  List<Operation> undoList;
  List<Operation> redoList;

  History._privateConstructor() {
    _init();
  }

  static History _instance = null;

  factory History() {
    if (_instance == null) {
      _instance = History._privateConstructor();
    }
    return _instance;
  }

  void _init() {
    undoList = List<Operation>();
    redoList = List<Operation>();
  }

  void push(Operation op) {
    undoList.add(op);
    redoList.clear();
  }

  void pop() {
    if (canUndo()) {
      Operation op = undoList.removeLast();
      op.undoAction();

      redoList.add(op);
    }
  }

  void restore() {
    if (canRedo()) {
      Operation op = redoList.removeLast();
      op.doAction();

      undoList.add(op);
    }
  }

  bool canUndo() {
    Log.i("canUndo " + undoList.length.toString());
    return undoList.length > 0;
  }

  bool canRedo() {
    Log.i("canRedo " + redoList.length.toString());
    return redoList.length > 0;
  }
}
