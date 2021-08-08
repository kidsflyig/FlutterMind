import 'package:FlutterMind/operations/History.dart';

class Operation {
  String descrition;
  Operation(this.descrition) {
    History().push(this);
  }

  void doAction() {
  }

  void undoAction() {
  }
}