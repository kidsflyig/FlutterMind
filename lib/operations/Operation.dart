import 'package:FlutterMind/operations/History.dart';

class Operation {
  bool will_record = true;
  String descrition;
  Operation(this.descrition) {
    if (will_record)
      History().push(this);
  }

  void doAction() {
  }

  void undoAction() {
  }
}